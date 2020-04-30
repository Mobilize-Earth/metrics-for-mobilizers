const admin = () => {
    document.getElementById('users-nav-link').addEventListener('click', () => {
        document.getElementById('content-users').style.display = 'block';
        document.getElementById('link-users').style.display = 'block';
        document.getElementById('users-nav-link').classList.add('selected');
        document.getElementById('content-chapters').style.display = 'none';
        document.getElementById('link-chapters').style.display = 'none';
        document.getElementById('chapters-nav-link').classList.remove('selected');
    });

    document.getElementById('chapters-nav-link').addEventListener('click', () => {
        document.getElementById('content-users').style.display = 'none';
        document.getElementById('link-users').style.display = 'none';
        document.getElementById('users-nav-link').classList.remove('selected');
        document.getElementById('content-chapters').style.display = 'block';
        document.getElementById('link-chapters').style.display = 'block';
        document.getElementById('chapters-nav-link').classList.add('selected');
    });
}
export default admin;