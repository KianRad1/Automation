

function CreateDBTable(tabledata, tablecolumns, tablediv) {
    var table = new Tabulator("#" + tablediv, {
        reactiveData: true,
        selectable: 1,
        maxHeight: "100%",
        pagination: "local", //enable local pagination.
        paginationSize: 15,
        responsiveLayout: "hide",
        data: tabledata, //assign data to table
        layout: "fitColumns", //fit columns to width of table (optional)
        columns: tablecolumns,
        rowClick: function (e, row) { //trigger an alert message when the row is clicked
            Clear();
            key = row.getData().ID;
            hdfAction.Set('ID', key);
            cmbAction.SetEnabled(true);
        },
    });
    $("#downloadxlsx").click(function () {
        table.download("xlsx", "data.xlsx", { sheetName: "My Data" });
    });

    //trigger download of data.pdf file
}

function CreatePopupDBTable(tabledata, tablecolumns, tablediv) {
    var table = new Tabulator("#" + tablediv, {
        reactiveData: true,
        selectable: 1,
        maxHeight: "100%",
        pagination: "local", //enable local pagination.
        paginationSize: 15,
        responsiveLayout: "hide",
        data: tabledata, //assign data to table
        layout: "fitColumns", //fit columns to width of table (optional)
        columns: tablecolumns,
        rowClick: function (e, row) { //trigger an alert message when the row is clicked
            Clear();
            key = row.getData().ID;
            hdfPopup.Set('ID', key);
            cmbAction.SetEnabled(true);
        },
    });


}
//     var tabledata = [
//{ id: 1, name: "Oli Bob", age: "12", col: "red", dob: "" },
//{ id: 2, name: "Mary May", age: "1", col: "blue", dob: "14/05/1982" },
//{ id: 3, name: "Christine Lobowski", age: "42", col: "green", dob: "22/05/1982" },
//{ id: 4, name: "Brendon Philips", age: "125", col: "orange", dob: "01/08/1980" },
//{ id: 5, name: "Margret Marmajuke", age: "16", col: "yellow", dob: "31/01/1999" },
//     ];
