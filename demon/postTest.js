
async function runTest(METHOD,link,payload) {
    try {
        const response = await fetch(link, {
            method: METHOD,
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)  
        });
        const result = await response.json();  
        if (response.ok) {
            console.log( JSON.stringify(result));
        } else {
            console.log(JSON.stringify(result));
        }
    } catch (error) {
        console.log('Request failed: ' + error.message);
    }
}


// METHOD =>
//      GET     (if crud = /get)
//      POST    (else)

// crud =>
//      /create
//      /get
//      /update
//      /delete

//  type =>
//       Semester
//       Category
//       CategoryPermission
//                      All
//                      Read
//                      Create
//                      
//
//

//  PARAM       (if crud = /get)
//      PARAMTYPE
//      PARAMVALUE
//  IF MULTIPLE RIP IDK 

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
let METHOD='POST'
const crud='/get'
const type='UserLogin'


// ONLY for GET method, can leave this alone if POST
const PARAMTYPE='?semester_id'
const PARAMVALUE='=2024/2025-1'

const payload = {
    session_id: 'ab',
    new_semester_id: '2099/2012-3',
    semester_id: '2024/2025-2',
    category_name: 'Personal',
    new_category_name: 'KUCING',
    // username : "12085",
    // password : "S808323",
    username : "johnAcad",
    password : "johnAcad",
    ref_name :"My Marks ",
    desc : "Marks for all subject",
    link :"google.com",
};

const endpoint=crud+type
let link=host+endpoint

if(METHOD=='GET'){
    link+= PARAMTYPE+PARAMVALUE
    runTest(METHOD,link);
}

else
    runTest(METHOD,link,payload);


// ===================================================
// ===================================================
//                  SEMESTER
// ===================================================
// ===================================================

// http://localhost/getUserLogin
// request body =>
//       username : ??  
//       password : ?? 




// ===================================================
// ===================================================
//                  SEMESTER
// ===================================================
// ===================================================


// http://localhost/getSemester

// http://localhost/createSemester
// request body =>
//       session_id : ??  ======= get from localStorage
//       semester_id : ?? ======= get from fill form

// http://localhost/deleteSemester
// request body =>
//       session_id : ??  ======= get from localStorage
//       semester_id : ?? ======= get from click

// http://localhost/updateSemester
// request body =>
//       session_id : ??  ======= get from localStorage
//       semester_id : ?? ======= get from click
//       new_semester_id : ====== get from fill form




// ===================================================
// ===================================================
//                  CATEGORY
// ===================================================
// ===================================================



// http://localhost/getCategory             CAN VIEW PERMISSIBLE CATEGORY ONLY
// request body =>
//       session_id : ??     ======= get from localStorage
//       semester_id : ??    ======= get from localStorage  

// http://localhost/createCategory          ACADEMIC OFFICER ONLY
// request body =>
//       session_id : ??     ======= get from localStorage
//       semester_id : ??    ======= get from localStorage
//       category_name : ??  ======= get from fill form

// http://localhost/deleteCategory          ACADEMIC OFFICER ONLY
// request body =>
//       session_id : ??     ======= get from localStorage
//       semester_id : ??    ======= get from localStorage
//       category_name : ??  ======= get from click

// http://localhost/updateCategory          ACADEMIC OFFICER ONLY
// request body =>
//       session_id : ??  ======= get from localStorage
//       semester_id : ?? ======= get from localStorage
//       category_name : ?? ===== get from click
//       new_category_name : ==== get from fill form


// ===================================================
// ===================================================
//              LINKS 
// ===================================================
// ===================================================


// http://localhost/getLink             CAN VIEW PERMISSIBLE LINKS ONLY
// request body =>
//       session_id : ??     ======= get from localStorage
//       semester_id : ??    ======= get from localStorage  
//       category_name : ??  ======= get from localStorage

// http://localhost/createLink         ONLY FOR ACADEMIC OFFICER & PEOPLE WITH CREATE PERM WITHIN CATEGORY
// request body =>
//        session_id : ??     ======= get from localStorage
//        semester_id : ??    ======= get from localStorage  
//        category_name : ??  ======= get from localStorage
//        ref_name : ??       ======= get from fill form
//        desc : ??           ======= get from fill form
//        link : ??           ======= get from fill form

// http://localhost/deleteLink        ONLY FOR ACADEMIC OFFICER & PEOPLE WITH DELETE PERM WITHIN CATEGORY & LINK OWNER
// request body =>
//       session_id : ??     ======= get from localStorage
//       semester_id : ??    ======= get from localStorage
//       category_name : ??  ======= get from localStorage
//       link id       : ??  ======= get from click

// http://localhost/updateLink          ONLY FOR ACADEMIC OFFICER & PEOPLE WITH UPDATE PERM WITHIN CATEGORY & LINK OWNER
// request body =>
//       session_id : ??    ======= get from localStorage
//       semester_id : ??   ======= get from localStorage
//       category_name : ?? ======= get from localStorage
//       link uh this is hard



// ===================================================
// ===================================================
//              CATEGORY PERMISSION
// ===================================================
// ===================================================

