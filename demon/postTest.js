
async function createCategories(link,payload) {
    try {
        const response = await fetch(link, {
            method: 'POST',
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
const endpoint='/deleteSemester'

const payload = {
    session_id: '313',
    semester_id: '2099/2100-2',
    category_name: 'PSM 4',
};

const link=host+endpoint
createCategories(link,payload);



// http://localhost/createSemester
// request body =>
//       session_id : ??  ======= get from localStorage
//       semester_id : ?? i.e 2024/2025-1


// http://localhost/createCategory
// request body =>
//       session_id : ??     ======= get from localStorage
//       semester_id : ??    ======= get from localStorage
//       category_name : ??