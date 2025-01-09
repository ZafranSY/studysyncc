
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
//                      Delete
//                      Create
//                      Update
//
//

//  PARAM       (if crud = /get)
//      PARAMTYPE
//      PARAMVALUE
//  IF MULTIPLE RIP IDK 

// eslint-disable-next-line no-unused-vars
const b=
{
    "session_id": "313",
    "new_semester_id": "2099/2012-3",
    "semester_id": "2099/3212-2",
    "category_name": "PSM 414",
    "new_category_name": "KUCING"
}

const host='http://localhost:80'
let METHOD='POST'
const crud='/get'
const type='CategoryPermissionView'


// ONLY for GET method, can leave this alone if POST
const PARAMTYPE='?semester_id'
const PARAMVALUE='=2099/3212-2'

const payload = {
    session_id: '313',
    new_semester_id: '2099/2012-3',
    semester_id: '2022/2023-2',
    category_name: 'PSM 414',
    new_category_name: 'KUCING',
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


// http://localhost/getSemester

// http://localhost/createSemester
// request body =>
//       session_id : ??  ======= get from localStorage
//       semester_id : ?? i.e 2024/2025-1

// http://localhost/deleteSemester
// request body =>
//       session_id : ??  ======= get from localStorage
//       semester_id : ?? i.e 2024/2025-1 

// http://localhost/updateSemester
// request body =>
//       session_id : ??  ======= get from localStorage
//       semester_id : ?? i.e 2024/2025-1   
//       new_semester_id : ?? i.e 2024/2025-1




// ===================================================
// ===================================================
//                  CATEGORY
// ===================================================
// ===================================================



// http://localhost/getCategory?semester_id=2024/2025-1
// param => 
//      semester_id          ======= get from localStorage

// http://localhost/createCategory
// request body =>
//       session_id : ??     ======= get from localStorage
//       semester_id : ??    ======= get from localStorage
//       category_name : ??

// http://localhost/deleteCategory
// request body =>
//       session_id : ??     ======= get from localStorage
//       semester_id : ??    ======= get from localStorage
//       category_name : ??

// http://localhost/updateCategory
// request body =>
//       session_id : ??  ======= get from localStorage
//       semester_id : ?? ======= get from localStorage
//       category_name : ??
//       new_category_name : ?? i.e 2024/2025-1


// http://localhost/createCategory
// request body =>
//       session_id : ??     ======= get from localStorage
//       semester_id : ??    ======= get from localStorage
//       category_name : ??


// ===================================================
// ===================================================
//              CATEGORY PERMISSION
// ===================================================
// ===================================================

// http://localhost/getCategoryPermissionAll
// request body =>
//       session_id : ??     ======= get from localStorage
//       semester_id : ??    ======= get from localStorage 

// http://localhost/getCategoryPermissionCreate
// request body =>
//       session_id : ??     ======= get from localStorage
//       semester_id : ??    ======= get from localStorage 

// http://localhost/getCategoryPermissionUpdate
// request body =>
//       session_id : ??     ======= get from localStorage
//       semester_id : ??    ======= get from localStorage 

// http://localhost/getCategoryPermissionRead
// request body =>
//       session_id : ??     ======= get from localStorage
//       semester_id : ??    ======= get from localStorage 

// http://localhost/getCategoryPermissionDelete
// request body =>
//       session_id : ??     ======= get from localStorage
//       semester_id : ??    ======= get from localStorage 


// http://localhost/createCategoryPermission
// request body =>
//       session_id : ??     ======= get from localStorage
//       semester_id : ??    ======= get from localStorage
//       category : ??
//       can_create : ??
//       can_read : ??
//       can_update : ??
//       can_delete : ??
//       role_name  : ??
//       user_email : ??