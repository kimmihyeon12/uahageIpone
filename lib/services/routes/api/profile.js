// route/api/profile.js
const express = require("express");
const aws = require("aws-sdk");
const multerS3 = require("multer-s3");
const multer = require("multer");
const path = require("path");
const url = require("url");
require("dotenv/config");

/**
 * express.Router() creates modular, mountable route handlers
 * A Router instance is a complete middleware and routing system; for this reason, it is often referred to as a “mini-app”.
 */
const router = express.Router();
router.use(express.json());
/**
 * PROFILE IMAGE STORING STARTS
 */
const s3 = new aws.S3({
  accessKeyId: process.env.accessKeyId,
  secretAccessKey: process.env.secretAccessKey,
  // bucket: "uahage",
});

/**
 * delete image from AWS S3
 */
router.post("/deleteImage", (req, res) => {
  const  fileName  = req.body.fileName;
  console.log("delete request");
  console.log(fileName);
  let data = fileName.split('/');
  let file = data[data.length - 1].replace("%40", "@"); //"1611718253052akobidov777%40gmail.comkakao.jpg"; //
  console.log(file);

  // res.end();
  s3.deleteObject(
    {
      Bucket: process.env.bucket,
      Key: file,
    },
    function (err, data) {
      if (err) {
        console.log(err);
        res.sendStatus(404);
      } else {
        console.log("success");
        res.sendStatus(200);
      }
    }
  );
});

/**
 * Single Upload
 */
const profileImgUpload = multer({
  storage: multerS3({
    s3: s3,
    bucket: process.env.bucket,
    acl: process.env.acl,
    key: function (req, file, cb) {
      cb(
        null,
        // path.basename(file.originalname, path.extname(file.originalname)) +
        //   "-" +
        Date.now() + req.params.id + path.extname(file.originalname)
      );
    },
  }),
  limits: { fileSize: 3145728 }, // In bytes: 2000000 bytes = 2 MB
  fileFilter: function (req, file, cb) {
    checkFileType(file, cb);
  },
}).single("profileImage");
/**
 * Check File Type
 * @param file
 * @param cb
 * @return {*}
 */
function checkFileType(file, cb) {
  // Allowed ext
  const filetypes = /jpeg|jpg|png|gif/;
  // Check ext
  const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
  // Check mime
  // const mimetype = filetypes.test(file.mimetype);
  if (extname) {
    return cb(null, true);
  } else {
    cb("Error: Images Only!");
  }
}
/**
 * @route POST api/profile/business-img-upload
 * @desc Upload post image
 * @access public
 */
router.post("/imgUpload/:id", (req, res) => {
  let id = req.params.id;
  profileImgUpload(req, res, (error) => {
    console.log("requestOkokok", req.file);
    console.log("error", error);
    if (error) {
      console.log("errors", error);
      res.json({ error: error });
    } else {
      // If File not found
      if (req.file === undefined) {
        console.log("Error: No File Selected!");
        res.json("Error: No File Selected");
      } else {
        // If Success
        const imageName = req.file.key;
        const imageLocation = req.file.location;
        // Save the file name into database into profile model
        res.status(200).json({
          image: imageName,
          location: imageLocation,
        });
      }
    }
  });
});
// End of single profile upload
/**
 * BUSINESS GALLERY IMAGES
 * MULTIPLE FILE UPLOADS
 */
// Multiple File Uploads ( max 4 )
// const uploadsBusinessGallery = multer({
//   storage: multerS3({
//     s3: s3,
//     bucket: "uahage",
//     acl: "public-read",
//     key: function (req, file, cb) {
//       cb(
//         null,
//         path.basename(file.originalname, path.extname(file.originalname)) +
//           "-" +
//           Date.now() +
//           path.extname(file.originalname)
//       );
//     },
//   }),
//     limits: { fileSize: 5000000 }, // In bytes: 2000000 bytes = 2 MB
//     fileFilter: function (req, file, cb) {
//       checkFileType(file, cb);
//     },
// }).array("galleryImage", 4);
/**
 * @route POST /api/profile/business-gallery-upload
 * @desc Upload business Gallery images
 * @access public
 */
// router.post("/multiple-file-upload", (req, res) => {
//   uploadsBusinessGallery(req, res, (error) => {
//     console.log("files", req.files);
//     if (error) {
//       console.log("errors", error);
//       res.json({ error: error });
//     } else {
//       // If File not found
//       if (req.files === undefined) {
//         console.log("Error: No File Selected!");
//         res.json("Error: No File Selected");
//       } else {
//         // If Success
//         let fileArray = req.files,
//           fileLocation;
//         const galleryImgLocationArray = [];
//         for (let i = 0; i < fileArray.length; i++) {
//           fileLocation = fileArray[i].location;
//           console.log("filenm", fileLocation);
//           galleryImgLocationArray.push(fileLocation);
//         }
//         // Save the file name into database
//         res.json({
//           filesArray: fileArray,
//           locationArray: galleryImgLocationArray,
//         });
//       }
//     }
//   });
// });
// We export the router so that the server.js file can pick it up
module.exports = router;
