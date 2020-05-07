import Charts from './charts';
import reportTable from './table';

const stripHash = hash => hash ? hash.substring(1) : '';
const numberFormatter = new Intl.NumberFormat('en-US');

const setDateRange = (start, end) => {
    for (const ele of document.getElementsByClassName('report-page-start-date')) {
        ele.textContent = start;
    }
    for (const ele of document.getElementsByClassName('report-page-end-date')) {
        ele.textContent = end;
    }
}

const setFilterDayCount = num => {
    for (const ele of document.getElementsByClassName('filter-day-count')) {
        ele.textContent = num;
    }
}

const setActiveFilter = ele => {
    for (const filterLink of document.getElementsByClassName('nav-link')) {
        filterLink.classList.remove('active');
    }

    ele.classList.add('active');
}

const setURLHash = (hash) => {
    location.hash = hash;
};

function getCurrentQueryParams() {
    let currentUrl = new URL(window.location.href);
    let params = currentUrl.searchParams;
    let country = params.get('country');
    let state = params.get('state');
    let region = params.get('region');
    let chapter = params.get('chapter');

    const dateRange = location.hash ? stripHash(location.hash) : 'week';
    let queryParams = {dateRange};
    if (country) queryParams.country = country;
    if (state) queryParams.state = state;
    if (region) queryParams.region = region;
    if (chapter) queryParams.chapter = chapter;
    return queryParams;
}

const getReportsTilesData = () => {
    let queryParams = getCurrentQueryParams();
    startTurbolinksProgress();
    $.ajax({
        url: '/reports/tiles',
        type: 'get',
        data: queryParams
    }).done(data => {
        stopTurbolinksProgress();

        $('#members').html(data.members === undefined ? 0 : numberFormatter.format(data.members));
        parseTilesGrowthData($('#members-growth'), data.members_growth);

        $('#chapters').html(data.chapters === undefined ? 0 : numberFormatter.format(data.chapters));
        parseTilesGrowthData($('#chapters-growth'), data.chapters_growth);

        $('#mobilizations').html(data.mobilizations === undefined ? 0 : numberFormatter.format(data.mobilizations));
        parseTilesGrowthData($('#mobilizations-growth'), data.mobilizations_growth);

        $('#newsletter-signups').html(data.signups === undefined ? 0 : numberFormatter.format(data.signups));
        parseTilesGrowthData($('#newsletter-signups-growth'), data.signups_growth);

        $('#actions').html(data.actions === undefined ? 0 : numberFormatter.format(data.actions));
        parseTilesGrowthData($('#actions-growth'), data.actions_growth);

        $('#trainings').html(data.trainings === undefined ? 0 : numberFormatter.format(data.trainings));
        parseTilesGrowthData($('#trainings-growth'), data.trainings_growth);

        $('#arrestable-pledges').html(data.arrestable_pledges === undefined ? 0 : numberFormatter.format(data.arrestable_pledges));
        parseTilesGrowthData($('#arrestable-pledges-growth'), data.arrestable_pledges_growth);

        $('#subscriptions').html(data.subscriptions === undefined ? 0 : numberFormatter.format(data.subscriptions));
        parseSubscriptionTileGrowthData($('#subscriptions-growth'), data.subscriptions_growth);

        setDateRange(data.start_date, data.end_date);
    });
}

const parseTilesGrowthData = (element, data) => {
    applyGrowthStyles(element, data);
    element.html(data === undefined ? 0 : numberFormatter.format(data));
}

const parseSubscriptionTileGrowthData = (element, data) => {
    applyGrowthStyles(element, data);
    element.html(data === undefined ? 0 : `$${numberFormatter.format(data)}`);
}

const applyGrowthStyles = (element, data) => {
    element.removeClass('number-negative')
    element.parent().find('.fa').removeClass('fa-arrow-down').addClass('fa-arrow-up')

    if (data < 0) {
        element.addClass('number-negative')
        element.parent().find('.fa').removeClass('fa-arrow-up').addClass('fa-arrow-down')
    }
}



const getReportsChartsData = (queryParams) => {
    $.ajax({
        url: '/reports/charts/mobilizations',
        type: 'get',
        data: queryParams
    }).done(data => {
        Charts.initMobilizationsChart(data);
    });
}

const onHashChange = () => {
    let queryParams = getCurrentQueryParams();
    getReportsTilesData(queryParams);
    getReportsChartsData(queryParams);
    let dateRange = queryParams.dateRange;
    setActiveFilter(document.getElementById(`filter-${dateRange}`));

    switch (dateRange) {
        case "week":
            setFilterDayCount(7);
            break;
        case "month":
            setFilterDayCount(30);
            break;
        case "quarter":
            setFilterDayCount(90);
            break;
        case "half-year":
            setFilterDayCount(180);
            break;
    }
};

const registerFilterClickHandlers = () => {
    document.getElementById('filter-week')
        .addEventListener('click', () => setURLHash('week'));
    document.getElementById('filter-month')
        .addEventListener('click', () => setURLHash('month'));
    document.getElementById('filter-quarter')
        .addEventListener('click', () => setURLHash('quarter'));
    document.getElementById('filter-half-year')
        .addEventListener('click', () => setURLHash('half-year'));
}

const reports = () => {
    window.addEventListener("hashchange", onHashChange, false);
    window.addEventListener("hashchange", reportTable.updateTable, false);
    onHashChange();
    reportTable.init();
    reportTable.updateTable();

    registerFilterClickHandlers();
};

function startTurbolinksProgress() {
    if(!Turbolinks.supported) return;
    Turbolinks.controller.adapter.progressBar.setValue(0);
    Turbolinks.controller.adapter.progressBar.show();
}

function stopTurbolinksProgress() {
    if(!Turbolinks.supported) return;
    Turbolinks.controller.adapter.progressBar.hide();
    Turbolinks.controller.adapter.progressBar.setValue(100);
}

export default reports;