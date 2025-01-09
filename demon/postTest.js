const payload = {
    session_id: '313',
    semester_id: '2099/2100-2'
};

async function createSemester() {
    try {
        const response = await fetch('http://localhost:80/createSemester', {
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

createSemester();
