async function runTest(METHOD, link, payload) {
  try {
    const response = await fetch(link, {
      method: METHOD,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    });
    const result = await response.json();
    if (response.ok) {
      console.log(JSON.stringify(result));
    } else {
      console.log(JSON.stringify(result));
    }
  } catch (error) {
    console.log("Request failed: " + error.message);
  }
}


// eslint-disable-next-line no-unused-vars
const b=
{
    "session_id": "ab",
    "new_semester_id": "2099/2012-3",
    "semester_id": "2099/3212-2",
    "category_name": "PSM 414",
    "new_category_name": "KUCING",
    "username" : "12085",
    "password" : "S808323",
    "username1" : "A16CS4016",
    "password1" : "201608M10112",
}

const host='http://localhost:80'
let METHOD='post'
const crud='/'
const type='updateLink'


// ONLY for GET method, can leave this alone if POST
const PARAMTYPE = "?semester_id";
const PARAMVALUE = "=2024/2025-1";

const payload = {
    session_id: 'ab',

  semester_id: "2024/2025-1",
  category_name: "Meow",

  new_semester_id: "2099/2012-3",
  new_category_name: "Meow",
  // username : "12085",
  // password : "S808323",
  username: "johnAcad",
  password: "johnAcad",

  ref_name: "History Black Catto",
  desc: "The detailed untold history",
  link: "google.com",

    gdlink_id : "11230",
    new_ref_name : 'white cat' ,
    new_desc : 'orange cat ',
    new_link : 'whatss.com',
    
};

const endpoint = crud + type;
let link = host + endpoint;

if (METHOD == "GET" || METHOD == "get") {
  link += PARAMTYPE + PARAMVALUE;
  runTest(METHOD, link);
} else runTest(METHOD, link, payload);
