const AWS = require("aws-sdk");
const S3 = new AWS.S3();

const downloadFile = async (bucket, key) => {
  try {
    console.log(`downloadFile with bucket: ${bucket} and key: ${key}`);

    // Converted it to async/await syntax just to simplify.
    const data = await S3.getObject({
      Bucket: bucket,
      Key: key,
    }).promise();
    return {
      statusCode: 200,
      body: data.Body,
    };
  } catch (err) {
    return {
      statusCode: err.statusCode || 400,
      body: err.message || JSON.stringify(err.message),
    };
  }
};

const getQueryResults = async (outputLocation) => {
  try {
    const url = new URL(outputLocation);
    results = await downloadFile(url.host, url.pathname.substring(1));
    return "" + results.body;
  } catch (error) {
    console.error("Invalid URL: \n" + outputLocation);
    console.error(error);
  }
};

exports.getQueryResults = getQueryResults;
