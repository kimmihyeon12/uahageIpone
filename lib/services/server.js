const express = require("express");
const app = express();
const bodyParser = require("body-parser");
var mysql = require("mysql");
const profile = require("./routes/api/profile");
require('dotenv').config();
app.use("/api/profile", profile);
var connection = mysql.createConnection({
  host: process.env.HOST_NAME,
  user: process.env.USER_NAME,
  password: process.env.PASSWORD,
  database: process.env.DATABASE_NAME,
});
connection.connect(function (err) {
  if (err) {
    console.error("error connecting: " + err.stack);
    return;
  }

  console.log("connected as id " + connection.threadId);
});

app.use(express.json());
app.set("view engine", "pug");
let zoomLevel = 2;
let lat;
let long;

//
app.get("/map", (req, res) => {
  zoomLevel = 4;
  console.log("map request");
  res.render("index.pug", {
    lat: 37.566826,
    long: 127.9786567,
    zoomInTo: zoomLevel,
  });
});

app.get("/zoomOut1", (req, res) => {
  zoomLevel += 1;
  lat = Math.abs(parseFloat(req.query.lat));
  long = Math.abs(parseFloat(req.query.long));
  res.render("index.pug", { lat: lat, long: long, zoomInTo: zoomLevel });
});

app.get("/getPos", (req, res) => {
  zoomLevel = 4;
  console.log(req.query);
  lat = Math.abs(parseFloat(req.query.lat));
  long = Math.abs(parseFloat(req.query.long));
  
  res.render("index.pug", { lat: lat, long: long, zoomInTo: zoomLevel });
});

app.get("/zoomIn", (req, res) => {
  if (zoomLevel >= 1) zoomLevel -= 1;
  lat = Math.abs(parseFloat(req.query.lat));
  long = Math.abs(parseFloat(req.query.long));
  res.render("index.pug", { lat: lat, long: long, zoomInTo: zoomLevel });
});

app.get("/zoomOut", (req, res) => {
  zoomLevel += 1;
  lat = Math.abs(parseFloat(req.query.lat));
  long = Math.abs(parseFloat(req.query.long));
  res.render("index.pug", { lat: lat, long: long, zoomInTo: zoomLevel });
});

app.get("/getAddress", (req, res) => {
  zoomLevel = 7;
  let address = req.query.address;
  console.log(address);
  res.render("search.pug", {
    lat: 37.566826,
    long: 127.9786567,
    zoomInTo: zoomLevel,
    address: address,
    zoomInTo: zoomLevel,
  });
});

app.get("/searchCategory", (req, res) => {
  zoomLevel = 4;
  lat = Math.abs(parseFloat(req.query.lat));
  long = Math.abs(parseFloat(req.query.long));
  
  let {menu,bed,tableware,meetingroom,diapers,playroom,carriages,nursingroom,chair,Area,Locality} = req.query;
  let address = Area + " " + Locality;
  
  let request1 = [
    menu,
    bed,
    tableware,
    meetingroom,
    diapers,
    playroom,
    carriages,
    nursingroom,
    chair,
  ];
  const body1 = [
    "menu",
    "bed",
    "tableware",
    "meetingroom",
    "diapers",
    "playroom",
    "carriage",
    "nursingroom",
    "chair",
  ];
  let sql1 = "";
  let query1 = "";
  let count = 0;
  for (let i = 0; i < request1.length; i++) {
    if (request1[i] == "false") {
      ++count;
      query1 = " " + body1[i] + " ='○' ";
      if (count > 1) {
        sql1 += " and " + query1;
      } else {
        sql1 += query1;
      }
    }
  }
 // sql = sql1 == "" ? "" : "select * from restaurant where address like '%"+address+"%' and" + sql1+ ";";
  sql = sql1 == "" ? "" : "select * from restaurant";
  console.log(sql1);
  console.log(sql);
  let resultData = [];
  if (sql == "") {
    res.render("index.pug", {
      data: resultData,
      lat: lat,
      long: long,
      zoomInTo: zoomLevel,
    });
  } else {
    try {
      connection.query(sql, (err, results) => {
        if (err) {
          console.log(err);
          res.end();
        } else {
          console.log(results.length);
          for (let i = 0; i < results.length; i++) {
            // console.log(results[i]);
            resultData.push({
              store_name: results[i]["store_name"],
              address: results[i]["address"],
              phone: results[i]["phone"],
              menu: results[i]["menu"],
              bed: results[i]["bed"],
              tableware: results[i]["tableware"],
              meetingroom: results[i]["meetingroom"],
              diapers: results[i]["diapers"],
              playroom: results[i]["playroom"],
              carriage: results[i]["carriage"],
              nursingroom: results[i]["nursingroom"],
              chair: results[i]["chair"],
              lat: results[i]["lat"],
              lon: results[i]["lon"],
            });
            // resultData.push(results[i]["address"]);
          }
          // console.log(resultData);
          res.render("serchmarker.pug", {
            data: resultData,
            lat: lat,
            long: long,
            zoomInTo: zoomLevel,
          });
          // console.log(resultData);
        }
      });
    } catch (error) {
      console.log(error);
      res.end();
    }
  }
});

app.get("/getList/:liststringdata", (req, res) => {
  let liststringdata = req.params.liststringdata;
  // console.log(liststringdata);
  let maxCount = parseInt(req.query.maxCount);
  // console.log("max count: ");
  console.log(`maxCount: ${maxCount}`);
  let sql = "SELECT * FROM " + liststringdata +" limit ?, 10"; // + " limit 10 offset " + maxCount + ";";
  console.log(sql);
  connection.query(sql, [maxCount],(err, rows) => {
    if (err) {
      console.log(err);
      res.json({ error: err });
      // render to views/books/index.ejs
    } else {
      // render to views/books/index.ejs
      console.log(rows.length);
      res.status(200).json(rows);
    }
  });
});

app.get("/getNicknames/:nickname", async (req, res) => {
  let nickcname = req.params.nickname;
  console.log(nickcname);
  let sql = "select * from myPage where nickname = ?";
  try {
    connection.query(sql, [nickcname], (err, results) => {
      if (err) {
        res.status(404).json({ err: err });
      } else {
        console.log(results);
        if (results.length == 0)
          res.status(200).json({ message: "사용 가능한 닉네임입니다." });
        else res.status(404).json({ message: "이미 사용중인 닉네임입니다." });
      }
    });
  } catch (error) {
    res.status(404).json({ err: error });
  }
});

app.post("/updateNickname/:nickname", async (req, res) => {
  let nickname = req.params.nickname;
  // let oldNickname = req.body.oldNickname;
  let gender = req.body.gender;
  let birthday = req.body.birthday;
  let age = req.body.age;
  let userId = req.body.userId;

  console.log(nickname), console.log(userId);
  console.log(req.body);
  let sql =
    "update myPage AS a, (SELECT email FROM myPage where email = ? ) as b SET a.nickname = ?, a.gender = ?, a.birthday = ?, a.age = ? WHERE a.email = b.email;";
  console.log(sql);
  try {
    connection.query(
      sql,
      [userId, nickname, gender, birthday, age],
      (err, results) => {
        if (err) {
          // console.log(err);
          res.status(404).json({ err: err });
        } else {
          console.log(results);
          if (results.affectedRows != 0) {
            res.status(200).json({ message: "성공적으로 업데이트됨" }); // Updated successfully.
          } else {
            res.status(200).json({ message: "업데이트할 수 없습니다" }); //Could not update
          }
          res.end();
        }
      }
    );
  } catch (error) {
    console.log(error);
    res.status(404).json({ message: error });
  }
});

app.get("/storename", (req, res) => {
  let storename = req.query.storename;
  let address = req.query.address;
  console.log(storename);
  console.log(address);
  res.render("storenamemarker.pug", {
    // lat: 37.566826,
    // long: 127.9786567,
    storename: storename,
    address: address,
    zoomInTo: 1,
  });
});

app.post("/saveUser", async (req, res) => {
  let nickname = req.body.nickname;
  let gender = req.body.gender;
  let birthday = req.body.birthday;
  let age = req.body.age;
  let email = req.body.email;
  let URL = req.body.URL;
  console.log(req.body);
  let sql = "insert into myPage values (?)";
  try {
    connection.query(
      sql,
      [[email, nickname, gender, birthday, age, URL]],
      (err, results) => {
        if (err) {
          console.log(err.sqlMessage);
          res.status(404).json({ message: err.sqlMessage });
        } else {
          console.log(results);
          if (results.affectedRows == 1) {
            res
              .status(200)
              .json({ message: "데이터가 성공적으로 저장되었습니다" }); // saved success
          } else {
            res.status(500).json({ message: "오류가 발생했습니다" }); //Error occured
          }
        }
      }
    );
  } catch (error) {
    res.status(404).json({ message: "저장할 수 없습니다" }); // Could not save
  }
});

//to load nickname on myPage
app.get("/getMyNickname", async (req, res) => {
  let userId = req.query.userId;
  console.log(userId);
  let sql = "select nickname from myPage where email = ?";
  try {
    connection.query(sql, [userId], (err, results) => {
      if (err) {
        res.status(404).json({ message: err.sqlMessage });
      } else {
        console.log("get mynickname ");
        console.log(results);
        res.status(200).json(results[0]);
      }
    });
  } catch (error) {
    res.status(404).json({ message: error });
  }
});

app.get("/getMyInfo", async (req, res) => {
  let userId = req.query.userId;
  console.log(userId);
  let sql = "select * from myPage where email = ?";
  try {
    connection.query(sql, [userId], (err, results) => {
      if (err) {
        res.status(404).json({ message: err.sqlMessage });
      } else {
        console.log(results);
        res.status(200).json(results[0]);
      }
    });
  } catch (error) {
    res.status(404).json({ message: error });
  }
});

app.get("/getEmail", async (req, res) => {
  let email = req.query.email;
  console.log(email);
  let sql = "select * from myPage where email = ?";
  try {
    connection.query(sql, [email], (err, results) => {
      if (err) {
        res.status(404).json({ message: err.sqlMessage });
      } else {
        console.log(results.length);
        res.status(200).json({ length: results.length });
      }
    });
  } catch (error) {
    res.status(404).json({ message: error });
  }
});

app.put("/updateImage/:id", (req, res) => {
  let id = req.params.id;
  let URL = req.body.URL;
  console.log(URL);
  let sql = `UPDATE myPage SET URL = ? WHERE email = ?`;
  try {
    connection.query(sql, [URL, id], (err, results, fields) => {
      console.log(results);
      if (err) {
        res.status(404).json({ message: err.sqlMessage });
      } else {
        res.status(200).json({ message: "성공적으로 업데이트되었습니다" }); //Successfully updated!
      }
    });
  } catch (error) {
    res.status(404).json({ message: error.sqlMessage });
  }
});
app.get("/getAvatar", async (req, res) => {
  let email = req.query.email;
  console.log(email);
  let sql = "select URL from myPage where email = ?";
  try {
    connection.query(sql, [email], (err, results) => {
      if (err) {
        res.status(404).json({ message: err.sqlMessage });
      } else {
        console.log("getAvatar ");
        console.log(results);
        if (results.length != 0)
          res.status(200).json({ image: results[0].URL });
        else res.status(404).json({ message: "Please log in first" });
      }
    });
  } catch (error) {
    res.status(404).json({ message: error });
  }
});

app.post("/star", async (req, res) => {
  let user_id = req.body.user_id;
  let store_name = req.body.store_name;
  let address = req.body.address;
  let phone = req.body.phone;
  let menu = req.body.menu;
  let bed = req.body.bed;
  let tableware = req.body.tableware;
  let meetingroom = req.body.meetingroom;
  let diapers = req.body.diapers;
  let playroom = req.body.playroom;
  let carriage = req.body.carriage;
  let nursingroom = req.body.nursingroom;
  let chair = req.body.chair;
  let fare = req.body.fare;
  let Examination_item = req.body.Examination_item;
  let star_color = req.body.star_color;
  let type = req.body.type;
  let id = null;
  // console.log(req.body);

  if (star_color) {
    let sql = "insert into star_list values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    connection.query(
      sql,
      [
        id,
        user_id,
        store_name,
        address,
        phone,
        menu,
        bed,
        tableware,
        meetingroom,
        diapers,
        playroom,
        carriage,
        nursingroom,
        chair,
        fare,
        Examination_item,
        type,
      ],
      (err, results) => {
        if (err) {
          console.log(err.sqlMessage);
          res.end();
        } else {
          console.log(results);
          res.end();
        }
      }
    );
  } else {
    let sql = "delete from star_list where user_id =? and address=? and id >0 ";
    connection.query(sql, [user_id, address], (err, results) => {res.send(results)});
  }
});


app.get("/starlist", (req, res) => {
  let user_id = req.query.user_id;

  console.log(user_id);

  let sql = "select * from star_list where user_id= ? ;";
  connection.query(sql, [user_id], (err, rows) => {
    if (err) {
      console.log(err);
      res.json({ error: err });
    } else {
      console.log(rows);
      res.status(200).json(rows);
    }
  });
});

app.get("/getStarColor", (req, res) => {
  const { userId, storeName } = req.query;
  console.log(userId);
  console.log(storeName);
  console.log(req.query);
  let sql = "select * from star_list where user_id = ? and store_name = ? ;";
  try {
    connection.query(sql, [userId, storeName], (err, results) => {
      if (err) {
        console.log(err);
        res.json({ error: err });
      } else {
        console.log(results);
        console.log(results.length);
        if (results.length > 0) res.sendStatus(200);
        else res.sendStatus(500);
      }
    });
  } catch (error) {
    console.log(error);
    res.status(404).json(error);
  }
  // res.end();
});

app.get("/starcolor", (req, res) => {
  let user_id = req.query.user_id;
  let tablename = req.query.tablename;
  console.log("starcolor");
  console.log(user_id);
  let sql =
    " select  st.store_name from " +
    tablename +
    " re left outer join (select * from star_list where user_id=? ) as st  on re.store_name = st.store_name; ";
  try {
    connection.query(sql, [user_id], (err, rows) => {
      if (err) {
        console.log(err);
        res.json({ error: err });
      } else {
        // console.log(rows);

        res.status(200).json(rows);
      }
    });
  } catch (error) {
    console.log(error);
    res.status(404).json(error);
  }
});

app.get("/substarcolor", (req, res) => {
  let user_id = req.query.user_id;
  let storename = req.query.storename;
  console.log(req.query);
  let sql =
    " select store_name from star_list where store_name = ? and user_id = ? ;";
  connection.query(sql, [storename, user_id], (err, rows) => {
    console.log(sql);

    if (err) {
      console.log(err);
      res.json({ error: err });
    } else {
      console.log("rows");
      console.log(rows);

      res.status(200).json(rows);
    }
  });
});

app.delete("/deleteProfile/:userId", (req, res) => {
  const userId = req.params.userId;
  console.log("delete profile");
  console.log(userId);
  let sql = "delete from myPage where email = ?;";
  try {
    connection.query(sql, [userId], (err, result) => {
      if (err) {
        res.status(404).json({ message: err.sqlMessage });
      } else {
        console.log(result);
        res.status(200).json({ message: "성공적으로 삭제됨" }); //Succesfully deleted
      }
    });
  } catch (error) {
    res.status(404).json({ message: error });
  }
});

// delete star
app.delete("/deleteStar/:userId", (req, res) => {
  const userId = req.params.userId;
  console.log("delete star");
  console.log(userId);
  let sql = "delete from star_list where user_id = ?;";
  try {
    connection.query(sql, [userId], (err, result) => {
      if (err) {
        res.status(404).json({ message: err.sqlMessage });
      } else {
        console.log(result);
        res.status(200).json({ message: "성공적으로 삭제됨" }); //Succesfully deleted
      }
    });
  } catch (error) {
    res.status(404).json({ message: error });
  }
});

app.get("/homesearch", (req, res) => {
  console.log("homesesarch");
  let {latitude, longitude, address} = req.query;
  let sql = "SELECT * FROM restaurant";

  let resultData = [];
  connection.query(sql, (err, results) => {
    if (err) {
      req.flash("error", err);
    } else {
      console.log(results.length);
      for (let i = 0; i < results.length; i++) {
        // console.log(results[i]);
        resultData.push({
          store_name: results[i]["store_name"],
          address: results[i]["address"],
          phone: results[i]["phone"],
          menu: results[i]["menu"],
          bed: results[i]["bed"],
          tableware: results[i]["tableware"],
          meetingroom: results[i]["meetingroom"],
          diapers: results[i]["diapers"],
          playroom: results[i]["playroom"],
          carriage: results[i]["carriage"],
          nursingroom: results[i]["nursingroom"],
          chair: results[i]["chair"],
          lat: results[i]["lat"],
          lon: results[i]["lon"],
        });
        // resultData.push(results[i]["address"]);
      }
      console.log(latitude);
      console.log(longitude);
      res.render("homesearch.pug", {
        lat: latitude,
        lon: longitude,
        data: resultData,
        address: address,
        zoomInTo: zoomLevel,
      });
      // console.log(resultData);
    }

    //   res.status(200).json(array);
    //  console.log(address);
  });
});

app.get("/searchlist", (req, res) => {
  let lat = req.query.lat;
  let long = req.query.long;
  let searchkey = req.query.searchkey;
  console.log("lat" + lat + "," + "long" + long + "," + searchkey);
  res.render("searchlist.pug", {
    lat: lat,
    long: long,
    searchkey: searchkey,
  });
});

app.get("/listsearchmarker/:liststringdata", (req, res) => {
  let liststringdata = req.params.liststringdata;
  let lat1 = req.query.lat;
  let lon1 = req.query.long;
  let Area = req.query.Area;
  let Locality = req.query.Locality;
  let address = Area +" "+ Locality;
   
  let sql = "SELECT * FROM " + liststringdata + " where address like '%"+address+"%' ;" ;
  console.log(sql);
  let resultData = [];

  console.log(sql);

  connection.query(sql, (err, results) => {
    if (err) {
      req.flash("error", err);
    } else {
      for (let i = 0; i < results.length; i++) {
        resultData.push({
          store_name: results[i]["store_name"],
          address: results[i]["address"],
          phone: results[i]["phone"],
          menu: results[i]["menu"],
          bed: results[i]["bed"],
          tableware: results[i]["tableware"],
          meetingroom: results[i]["meetingroom"],
          diapers: results[i]["diapers"],
          playroom: results[i]["playroom"],
          carriage: results[i]["carriage"],
          nursingroom: results[i]["nursingroom"],
          chair: results[i]["chair"],
          Examination_item: results[i]["Examination_item"],
          fare: results[i]["fare"],
          lat: results[i]["lat"],
          lon: results[i]["lon"],
        });
      }

      res.render("listsearchmarker.pug", {
        lat1: lat1,
        lon1: lon1,
        data: resultData,
        liststringdata: liststringdata,
      });
    }
  });
});

app.listen(process.env.PORT_ADDRESS, () => console.log("server is listening on port 3000"));
