<script>
import { useRouter } from 'vue-router';

export default {
    name: 'loginCheck',
    setup() {
        const router = useRouter();

        // Function to check the login session
        const checkLogin = () => {
            const sessionData = localStorage.getItem('utmwebfc_session');

            if (!sessionData) {
                console.log('No session found. Redirecting to login.');
                router.push('/login'); // Redirect to the login page
            } else {
                try {
                    const session = JSON.parse(sessionData);

                    // Validate session (e.g., check if it has a session_id)
                    if (!session.session_id) {
                        console.log('Invalid session data. Redirecting to login.');
                        router.push('/login');
                    } else {
                        console.log('Session valid:', session);
                    }
                } catch (e) {
                    console.error('Error parsing session data. Redirecting to login.', e);
                    router.push('/login');
                }
            }
        };

        // Perform the login check on component mount
        checkLogin();

        return {};
    }
};
</script>
