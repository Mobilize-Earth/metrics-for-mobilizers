import Charts from './charts';
import reportTable from './table';

const stripHash = hash => hash ? hash.substring(1) : '';

const setDateRange = (start, end) => {
    for (const ele of document.getElementsByClassName('report-page-start-date')) {
        ele.textContent = start;
    }
    for (const ele of document.getElementsByClassName('report-page-end-date')) {
        ele.textContent = end;
    }
}

const setFilterDayCount = num => document.getElementById('filter-day-count').textContent = num;

const setActiveFilter = ele => {
    for(const filterLink of document.getElementsByClassName('nav-link')) {
        filterLink.classList.remove('active');
    }

    ele.classList.add('active');
}

const setURLHash = (hash) => {
    location.hash = hash;
};

const getReportsTilesData = (dateRange) => {
    let currentUrl = new URL(window.location.href);
    let params = currentUrl.searchParams;
    let country = params.get('country');
    let state = params.get('state');
    let region = params.get('region');
    let chapter = params.get('chapter');

    let queryParams = { dateRange };
    if (country) queryParams.country = country;
    if (state) queryParams.state = state;
    if (region) queryParams.region = region;
    if (chapter) queryParams.chapter = chapter;

    $.ajax({
        url: '/reports/tiles',
        type: 'get',
        data: queryParams
    }).done(data => {
        $('#members').html(data.members === null ? 0 : data.members);
        $('#chapters').html(data.chapters === null ? 0 : data.chapters);
        $('#actions').html(data.actions === null ? 0 : data.actions);
        $('#trainings').html(data.trainings === null ? 0 : data.trainings);
        $('#mobilizations').html(data.mobilizations === null ? 0 : data.mobilizations);
        $('#pledges-arrestable').html(data.pledges_arrestable === null ? 0 : data.pledges_arrestable);
        $('#subscriptions').html(data.subscriptions === null ? 0 : data.subscriptions);
        setDateRange(data.start_date, data.end_date);
    });
}

const getReportsChartsData = (dateRange) => {
    $.ajax({
        url: '/reports/charts/mobilizations',
        type: 'get',
        data: {dateRange}
    }).done(data => {
        Charts.initMobilizationsChart(data);
    });
}

const onHashChange = () => {
    const hash = location.hash ? stripHash(location.hash) : 'week';
    getReportsTilesData(hash);
    getReportsChartsData(hash);

    setActiveFilter(document.getElementById(`filter-${hash}`));

    switch (hash) {
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

export default reports;