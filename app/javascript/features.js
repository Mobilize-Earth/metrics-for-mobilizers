import page from './page';
import reports from './reports';
import admin from './admin';

$(document).on('turbolinks:load', () => {
    switch (page.controllerName()) {
        case 'reports':
            reports();
            break;
        case 'admins':
            admin();
            break;
    }
});