import page from './page';
import reports from './reports';

$(document).on('turbolinks:load', () => {
    switch (page.controllerName()) {
        case 'reports':
            reports();
            break;
    }
});