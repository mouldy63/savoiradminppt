 function exportTableToCSV($table, filename) {
                var $headers = $table.find('tr:has(th)')
                    ,$rows = $table.find('tr:has(td)')
                    // Temporary delimiter characters unlikely to be typed by keyboard
                    // This is to avoid accidentally splitting the actual contents
                    ,tmpColDelim = String.fromCharCode(11) // vertical tab character
                    ,tmpRowDelim = String.fromCharCode(0) // null character
                    // actual delimiter characters for CSV format
                    ,colDelim = '","'
                    ,rowDelim = '"\r\n"';
                    // Grab text from table into CSV formatted string
                    var csv = '"';
                    csv += formatRows($headers.map(grabRow));
                    csv += rowDelim;
                    csv += formatRows($rows.map(grabRow)) + '"';
                    // Data URI
                    var csvData = 'data:application/csv;charset=utf-8,' + encodeURIComponent(csv);
                    //console.log(csvData);
                    if (window.navigator.msSaveOrOpenBlob) {
                        var blob = new Blob([decodeURIComponent(encodeURI(csv))], {
                            type: "text/csv;charset=utf-8;"
                        });
                        navigator.msSaveBlob(blob, filename);
                    } else {
                        $(this)
                            .attr({
                                'download': filename
                                ,'href': csvData
                                //,'target' : '_blank' //if you want it to open in a new window
                        });
                    }
                //------------------------------------------------------------
                // Helper Functions 
                //------------------------------------------------------------
                // Format the output so it has the appropriate delimiters
                function formatRows(rows){
                    return rows.get().join(tmpRowDelim)
                        .split(tmpRowDelim).join(rowDelim)
                        .split(tmpColDelim).join(colDelim);
                }
                // Grab and format a row from the table
                function grabRow(i,row){
                     
                    var $row = $(row);
                    //for some reason $cols = $row.find('td') || $row.find('th') won't work...
                    var $cols = $row.find('td'); 
                    if(!$cols.length) $cols = $row.find('th');  
                    return $cols.map(grabCol)
                                .get().join(tmpColDelim);
                }
                // Grab and format a column from the table 
                function grabCol(j,col){
                    var tmpColDelim = String.fromCharCode(11);
                    var $col = $(col);
                    var $text;
                    if($col.find('.set_target').length>0){
                        $text = $col.find('.set_target').val();
                    }else{
                        $text = $col.text();
                    }
                    if($col.hasClass('twotablecell')){
                        var ii;
                        for(ii=0;ii<1;ii++){
                            $text += tmpColDelim;
                        }
                    }
                    if($col.hasClass('fourtablecell')){
                        var ii;
                        for(ii=0;ii<3;ii++){
                            $text += tmpColDelim;
                        }
                    }
                    if($col.hasClass('sixtablecell')){
                        var ii;
                        for(ii=0;ii<5;ii++){
                            $text += tmpColDelim;
                        }
                    }
                    if($col.hasClass('eighttablecell')){
                        var ii;
                        for(ii=0;ii<7;ii++){
                            $text += tmpColDelim;
                        }
                    }
                    if($col.hasClass('tentablecell')){
                        var ii;
                        for(ii=0;ii<9;ii++){
                            $text += tmpColDelim;
                        }
                    }
                    if($col.hasClass('twofourtablecell')){
                        var ii;
                        for(ii=0;ii<23;ii++){
                            $text += tmpColDelim;
                        }
                    }
                    if($col.hasClass('threetwotablecell')){
                        var ii;
                        for(ii=0;ii<31;ii++){
                            $text += tmpColDelim;
                        }
                    }
                   // return $text.replace('"', '""'); // escape double quotes
                    return $text;
                }
            }