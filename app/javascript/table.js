let country, state, region, chapter, groupByProperty, groupByLabel, queryParams;
let xhr;
let data = {};

const stripHash = hash => hash ? hash.substring(1) : '';
const numberFormatter = new Intl.NumberFormat('en-US');

function init() {
    getContext();
    setGroupByHeaderLabel();
    makeTableSortable();
}

function updateTable() {
    if (xhr) xhr.abort(); //abort outstanding requests
    getContext();
    xhr = $.getJSON('/reports/table', queryParams);
    xhr.done((result) => {
        if (queryParams.chapter) result = [result.result];
        data = normalize(result);
        data = result.sort((x, y) => y.members - x.members);
        renderTableBody(result);
    });
    xhr.always(() => {
        xhr = undefined;//clear request
    });
}

function normalize(data) {
    return data.map(v => {
        if (!v.members) v.members = 0;
        if (!v.chapters) v.chapters = 0;
        if (!v.signups) v.signups = 0;
        if (!v.trainings) v.trainings = 0;
        if (!v.arrestable_pledges) v.arrestable_pledges = 0;
        if (!v.actions) v.actions = 0;
        if (!v.mobilizations) v.mobilizations = 0;
        if (!v.subscriptions) v.subscriptions = 0;
    })
}

function getContext() {
    let currentUrl = new URL(window.location.href);
    let params = currentUrl.searchParams;
    country = params.get('country');
    state = params.get('state');
    region = params.get('region');
    chapter = params.get('chapter');

    groupByProperty = 'country';
    groupByLabel = 'Countries';
    queryParams = {};
    if (country) {
        queryParams.country = country;
        if (country.toUpperCase() === 'US') {
            groupByProperty = 'region';
            groupByLabel = 'Regions';
        } else {
            groupByProperty = 'state';
            groupByLabel = 'States';
        }
    }

    if (region) {
        queryParams.region = region;
        groupByProperty = 'state';
        groupByLabel = 'States';
    }

    if (state) {
        queryParams.state = state;
        groupByProperty = 'chapter';
        groupByLabel = 'Chapters';

    }
    if (chapter) {
        queryParams.chapter = chapter;
        groupByProperty = 'chapter';
        groupByLabel = 'Chapter';
    }

    queryParams.period = location.hash ? stripHash(location.hash) : 'week';
}


function setGroupByHeaderLabel() {
    let groupByColHeader = $("table.report-table thead tr th").first();
    groupByColHeader.text(groupByLabel);
    groupByColHeader.attr('xr-table-key', groupByProperty);
    groupByColHeader.append('<i class="fa fa-sort"></i>')
}

function makeTableSortable() {
    let tableHead = $("table.report-table thead");
    tableHead.find("tr th").click(function () {
        let orderAsc = $(this).attr("asc");
        if (orderAsc) {
            $(this).removeAttr("asc");
            orderAsc = false;
        } else {
            $(this).attr("asc", "true");
            orderAsc = true;
        }
        sortBy($(this).attr("xr-table-key"), orderAsc);
    });
}

const sortString = (x, y, asc) => asc ? ("" + x).localeCompare(y) : ("" + y).localeCompare(x);
const sortNumber = (x, y, asc) => asc ? x - y : y - x;

function sortBy(columnName, asc) {
    let sort = isNaN(data[0][columnName]) ? sortString : sortNumber;
    let order = (x, y) => {
        return sort(x[columnName], y[columnName], asc);
    };
    data = data.sort(order);
    renderTableBody(data);
}

const record = (obj) => {
    let link = `/reports?`;
    let queryParams = [];

    if (country) queryParams.push(`country=${country}`);
    if (region) queryParams.push(`region=${region}`);
    if (state) queryParams.push(`state=${state}`);
    if (chapter) queryParams.push(`chapter=${chapter}`);
    queryParams.push(`${groupByProperty}=${obj.id}`)

    link += queryParams.join('&') + location.hash;
    link = encodeURI(link);

    let linkElement = chapter ? `${obj[groupByProperty]}` : `<a href=${link}>${obj[groupByProperty]}</a>`;

    return `<tr>
              <td scope="row">${linkElement}</td>
              <td>${numberFormatter.format(obj.chapters)}</td>
              <td>${numberFormatter.format(obj.members)}</td>
              <td>$${numberFormatter.format(obj.subscriptions)}</td>
              <td>${numberFormatter.format(obj.arrestable_pledges)}</td>
              <td>${numberFormatter.format(obj.mobilizations)}</td>
              <td>${numberFormatter.format(obj.trainings)}</td>
              <td>${numberFormatter.format(obj.signups)}</td>
              <td>${numberFormatter.format(obj.actions)}</td>
            </tr>`
};

function renderTableBody(data) {
    const tableBody = $("table.report-table tbody");
    tableBody.empty();
    if(data.length === 0){
        tableBody.append(`<tr>
                            <td colspan="9" class="empty_table">No chapters registered for this location.</td>
                          </tr>`)
    }else {
        $.each(data, function (i, v) {
            tableBody.append(record(v));
        });
    }
}


const table = {
    init: init,
    updateTable: updateTable
};

export default table;