
// ===================================================
// ===================================================
//                  LOGIN
// ===================================================
// ===================================================

// http://localhost/getUserLogin
// request body =>
//       username : ??  
//       password : ?? 
// special case,,,, username==password if exist in db, can login
// 


// ===================================================
// ===================================================
//                  SEMESTER
// ===================================================
// ===================================================


// http://localhost/getSemester

// http://localhost/createSemester              ACADEMIC OFFICER ONLY
// request body =>
//       session_id : ??  ======= get from localStorage
//       semester_id : ?? ======= get from fill form

// http://localhost/deleteSemester              ACADEMIC OFFICER ONLY
// request body =>
//       session_id : ??  ======= get from localStorage
//       semester_id : ?? ======= get from click
//  WARNING : DELETING SEMESTER ALSO DELETE ALL THINGS INSIDE OF IT


// http://localhost/updateSemester              ACADEMIC OFFICER ONLY
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
//  WARNING : DELETING CATEGORY ALSO DELETE ALL THINGS INSIDE OF IT


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




// ================BELOW IS WORK IN PROGRESS========================================================================================================
// ========BELOW IS WORK IN PROGRESS==============================BELOW IS WORK IN PROGRESS==================BELOW IS WORK IN PROGRESS===============
// =============================================BELOW IS WORK IN PROGRESS============================================================================
// ===============================================================================================BELOW IS WORK IN PROGRESS==========================
// =======================BELOW IS WORK IN PROGRESS==============BELOW IS WORK IN PROGRESS===========================================================
// =================BELOW IS WORK IN PROGRESS============================================================BELOW IS WORK IN PROGRESS===================
// =========================BELOW IS WORK IN PROGRESS================================================================================================


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

// http://localhost/getCategoryPermission
// http://localhost/updateCategoryPermission
// http://localhost/deleteCategoryPermission
// http://localhost/createCategoryPermission


// ===================================================
// ===================================================
//              LINK PERMISSION
// ===================================================
// ===================================================

// http://localhost/getLinkPermission
// http://localhost/updateLinkPermission
// http://localhost/deleteLinkPermission
// http://localhost/createLinkPermission
