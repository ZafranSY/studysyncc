    
    
    
    
    
    select gdlink_id from gdlinks 
                where owner='johnStu@utm.com'
                or gdlink_id IN (
                    select gdlink_id from linkPermission 
                        where (user_email='johnStu@utm.com' 
                                OR role_name='Everyone' 
                                OR role_name='Pelajar')
                        AND can_read=1)
                        AND category IN (
                            select DISTINCT category from categoryPermission 
                                where can_read_category=1 
                                AND (
                                role_name='Everyone' 
                                OR role_name='Student' 
                                OR user_email='johnStu@utm.my'
                                )
                        )
                        OR EXISTS (
                            SELECT 1 FROM user 
                            WHERE email = 'johnStu@utm.my'
                                AND role_id = (SELECT role_id FROM roles WHERE role_name = "Academic Officer")
                            );
