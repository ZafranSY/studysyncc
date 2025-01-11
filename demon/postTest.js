
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


const host='http://localhost:80'
let METHOD='post'
const crud='/delete'
const type='CategoryPermission'


// ONLY for GET method, can leave this alone if POST
const PARAMTYPE='?semester_id'
const PARAMVALUE='=2024/2025-1'

const payload = {
    session_id: '313',

    semester_id: '2024/2025-1',
    category_name: 'Meow',

    new_semester_id: '2099/2012-3',
    new_category_name: 'Meow',
    // username : "12085",
    // password : "S808323",
    username : "johnAcad",
    password : "johnAcad",

    ref_name :"History Black Catto",
    desc : "The detailed untold history",
    link :"google.com",

    gdlink_id : "11230",
    new_ref_name : 'white cat' ,
    new_desc : 'orange cat ',
    new_link : 'whatss.com',

    // insert_user_role : "Academic Officer",
    // insert_user_email : "johnStu@utm.com",
    can_read_category : false ,
    can_create_links : false,
    selected_user_role : 'Everyone',
    // selected_user_email : 'johnStu@utm.com',
    
};

const endpoint=crud+type
let link=host+endpoint

if(METHOD=='GET'||METHOD=='get'){
    link+= PARAMTYPE+PARAMVALUE
    runTest(METHOD,link);
}

else
    runTest(METHOD,link,payload);

