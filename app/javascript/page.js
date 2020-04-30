const Page = {
    controllerName: () => $('body').attr('data-controller'),
    actionName: () => $('body').attr('data-action'),
}

export default Page;