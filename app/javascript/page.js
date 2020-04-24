export default {
    controllerName: () => $('body').attr('data-controller'),
    actionName: () => $('body').attr('data-action'),
}