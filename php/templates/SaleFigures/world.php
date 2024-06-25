<?php
use Cake\Core\Configure;
use Cake\Routing\Router;
?>
<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>
<?php echo $this->Html->css('salefigures.css',array('inline' => false));?>
<?php echo $this->Html->script('htmlToJS.js', array('inline' => false)); ?>

<?php 
function getMonth($monthKey){
	$key = (int)$monthKey;
	switch($key){
		case 1:
			return 'JANUARY';
			break;
		case 2:
			return 'FEBRUARY';
			break;
		case 3:
			return 'MARCH';
			break;
		case 4:
			return 'APRIL';
			break;
		case 5:
			return 'MAY';
			break;
		case 6:
			return 'JUNE';
			break;
		case 7:
			return 'JULY';
			break;
		case 8:
			return 'AUGUST';
			break;
		case 9:
			return 'SEPTEMBER';
			break;
		case 10:
			return 'OCTOBER';
			break;
		case 11:
			return 'NOVEMBER';
			break;
		case 12:
			return 'DECEMBER';
			break;
	}
}

if($data == 'no') {
	echo "You don't have enough privilege to see this page.";
        die;
}
$currentMonth = (int)date('m');
$acl = $data['acl'];
$allFigures = $data['data'];
arsort($allFigures);
$allTargets = $data['target'];
$exchangeRate = $data['exchange_rate_array'];
$currentYear = (int)$data['requestyear'];
$thisYear = (int)$data['thisyear'];
echo $this->element('saleFiguresHeader', array("acl"=>$acl));
echo $this->element('saleFiguresControllPannel',array("isExchangeRateTable"=>false));
echo $this->element('saleFiguresTest',array('test'=>$data['test'],'action'=>'year'));
?>

<input id="thisyear" type="hidden" value="<?php echo $data['thisyear'];?>"/>
<div id="tableArea">
    <table id="theTable">
        <thead>
            <tr>
                <th class = "twotablecell emptycell bordercell"></th>
                <th class = "twofourtablecell bordercell norightcell">SAVOIR BEDS</th>
                <th class = "twotablecell emptycell bordercell noleftcell"></th>
            </tr>
            <tr style="background-color:white;">
                <th class = "twotablecell bordercell nobottomcell">YEAR: </th>
                <th class = "twotablecell bordercell nobottomcell">Year To Date<!--(<?php echo getMonth($currentMonth);?>)--></th>
	<?php for($ii=1;$ii<=12;$ii++): ?>
                <th class = "twotablecell bordercell nobottomcell"><?php echo getMonth($ii);?></th>
	<?php endfor;?>

            </tr>
            <tr style="background-color:white;">
                <th class = "twotablecell leftcell bottomcell"><select id="changeYear" onchange="changeYear(this);return false;";>
	<?php for($ii=$thisYear;$ii>=2012;$ii--):?>
		<?php if( $ii==$currentYear):?>
                        <option value="<?php echo $ii;?>" selected><?php echo $ii;?></option>
		<?php else:?>
                        <option value="<?php echo $ii;?>"><?php echo $ii;?></option>
		<?php endif;?>
	<?php endfor;?>
                    </select></th>
	<?php for($ii=1;$ii<=13;$ii++): ?>
                <th class = "tablecell bordercell">Target</th>
                <th class = "tablecell bordercell">Actual</th>
	<?php endfor;?>
            </tr>
        </thead>
        <tbody id="datatable">
            <tr><td class = "twotablecell emptycell bordercell">Savoir Owned</td>
<?php for($ii=1;$ii<=26;$ii++):?>
                <td class = "tablecell bordercell"></td>
                <?php endfor;?>
            </tr>
<?php
	$thisYear = date('Y');
	$thisMonth = date('m');
	foreach($allFigures as $yearKey=>$tempYearFigures):
		$tempYearTargets = $allTargets[$yearKey];
		$monthTotal=array_fill(1,12,0);
		$monthTargetTotal= array_fill(1,12,0);
		$YearToDateTotal = 0;
		$YearToDateTargetTotal = 0;
		foreach($tempYearFigures as $showroomKey=>$showroomFigures):
			$showroomTargets = $tempYearTargets[$showroomKey];
			$isGBP = true;
			$currencyStatus = '';
			$temRate = 1;
			$YearToDate = 0;
			$YearToDateTarget = 0;
			$YearToDateGBP = 0;
			$YearToDateTarget = 0;
			$YearToDateTargetGBP = 0;

                        if($showroomFigures['currency']!='GBP'){
				$isGBP = false;
				$currencyStatus = 'nativecurrency';
			}
			foreach($showroomFigures['figures'] as $monthKey=>$tempMonthFigures){
				if((int)$monthKey<=$currentMonth){
					if(!$isGBP){
						$temRate = $exchangeRate[$yearKey][$monthKey][$showroomFigures['currency']];
						$YearToDate += $tempMonthFigures;
						$YearToDateGBP += $tempMonthFigures/$temRate;
						$YearToDateTarget += $showroomTargets[$monthKey]['amount'];
						$YearToDateTargetGBP += $showroomTargets[$monthKey]['amount']/$temRate;
					}else{
						$YearToDate += $tempMonthFigures;
						$YearToDateGBP = $YearToDate;
						$YearToDateTarget += $showroomTargets[$monthKey]['amount'];
						$YearToDateTargetGBP = $YearToDateTarget;
					}
				}
			}
			$YearToDateTotal += $YearToDateGBP;
			$YearToDateTargetTotal += $YearToDateTargetGBP;
?>
            <tr>

                <td class = "twotablecell bordercell"><?php echo $showroomFigures['showroomName'];?> (<span class="native_currency_code" data-currency-code="<?php echo $showroomFigures['currency'];?>"><?php echo $showroomFigures['currency'];?></span>)</td>
                <td class = "tablecell bordercell <?php echo $currencyStatus;?>" data-currency-array="-1,<?php echo $YearToDateTargetGBP;?>,<?php echo $YearToDateTarget;?>"><?php echo number_format($YearToDateTarget,2,'.',',');?></td>
                <td class = "tablecell bordercell <?php echo $currencyStatus;?>" data-currency-array="-1,<?php echo $YearToDateTargetGBP;?>,<?php echo $YearToDateTarget;?>"><?php echo number_format($YearToDate,2,'.',',');?></td>
<?php 
			foreach($showroomFigures['figures'] as $monthKey=>$tempMonthFigures):
				if(!$isGBP){
				    $temRate = $exchangeRate[$yearKey][$monthKey][$showroomFigures['currency']];
					$monthTotal[(int)$monthKey] += $tempMonthFigures/$temRate;
				}
				else{
					$monthTotal[(int)$monthKey] += $tempMonthFigures;
				}
				$monthTargetTotal[(int)$monthKey] += $showroomTargets[$monthKey]['amount'];
?>

                <td class = "tablecell bordercell <?php echo $currencyStatus;?>" data-currency-array="<?php echo $showroomTargets[$monthKey]['amount'];?>,<?php echo $temRate;?>"><input class="set_target disablebg" onchange="allTargetsData.changeTarget(
			<?php echo $yearKey;?>,<?php echo $monthKey;?>,<?php echo $showroomKey;?>, this);return false;" type="text" value="<?php echo number_format($showroomTargets[$monthKey]['amount'],0,'.',',');?>" disabled/></td>
                <td class = "tablecell bordercell <?php echo $currencyStatus;?>" data-currency-array="<?php echo $tempMonthFigures;?>,<?php echo $temRate;?>"><?php echo number_format($tempMonthFigures,2,'.',','); ?></td>
<?php
			endforeach;
?>

            </tr>
<?php
		if($showroomKey == 39):
?>
            <tr><td class = "twotablecell emptycell bordercell"></td>
	<?php for($ii=1;$ii<=26;$ii++):?>
                <td class = "tablecell bordercell"></td>
	<?php endfor;?>
            </tr>
            <tr><td class = "twotablecell emptycell bordercell">Dealers</td>
	<?php for($ii=1;$ii<=26;$ii++):?>
                <td class = "tablecell bordercell"></td>
	<?php endfor;?>
            </tr>
<?php
		endif;
		endforeach;
	endforeach;
?>
            <tr><th class = "twotablecell emptycell bordercell"></th>
	<?php for($ii=1;$ii<=26;$ii++):?>
                <td class = "tablecell bordercell"></td>
	<?php endfor;?>
            </tr>
            <tr>
                <td class = "twotablecell bordercell">TOTAL(GBP):</td>
                <td class = "tablecell bordercell"><?php echo number_format($YearToDateTargetTotal,2,'.',','); ?></td>
                <td class = "tablecell bordercell"><?php echo number_format($YearToDateTotal,2,'.',','); ?></td>
<?php
	for($ii=1;$ii<=12;$ii++):
?>
                <td class = "tablecell bordercell"><?php echo number_format($monthTargetTotal[$ii],0,'.',',');?></td>
                <td class = "tablecell bordercell"><?php echo number_format($monthTotal[$ii],2,'.',','); ?></td>

<?php	
	endfor;
?>	

            </tr>
        </tbody>

    </table>
</div>


<script type="text/javascript">
    allTargetsData = {
        originalTarget:<?php echo json_encode($allTargets);?>,
        updatedTargets:<?php echo json_encode($allTargets);?>,
        realFigure: <?php echo json_encode($allFigures);?>,
        exchangeRate: <?php echo json_encode($exchangeRate);?>,
        isTableChanged: function () {
            if (this.updatedTargets == -1) {
                return false;
            } else {
                for (var k in this.updatedTargets) {
                    var tempYear = this.updatedTargets[k];
                    for (var t in tempYear) {
                        var tempMonth = tempYear[t];
                        for (var s in tempMonth) {
                            var tempShowroom = tempMonth[s];
                            if (tempShowroom['changed'] == 'y') {
                                return true;
                            }
                        }
                    }
                }

                return false;
            }
        },
        inputValidation: function (str) {
            if (str.match(/(?:\d*\.)?\d+/)) {
                if (str.match(/[a-zA-Z_+-,!@#$%^&*();\\/|<>"']+/)) {
                    return false;
                } else {
                    return true;
                }
            } else {
                return false;
            }
        },
        changeTarget: function (year, month, showroom, element) {
            var y = parseInt(year);
            var m = parseInt(month);
            var s = parseInt(showroom);
            var value = $(element).val();
            if (this.inputValidation(value)) {
                this.updatedTargets[y][s][m]['amount'] = value;
                this.updatedTargets[y][s][m]['changed'] = 'y';
                if (!$(element).hasClass('changed')) {
                }
                $(element).addClass('changed');
            } else {
                $(element).val('0');
                alert("please enter digits and don't use ','.");
            }
        },
        updateData: function (target, realSales, exchangeRate) {
            this.originalTarget = target;
            this.updatedTargets = target;
            this.realFigure = realSales;
            this.exchangeRate = exchangeRate;
        },
        saveToDB: function () {
            var thisObj = this;
            var requestYear = $('#changeYear').val();
            //console.log(this.updatedTargets);
            if (this.updatedTargets != -1) {
                var sendbackData = JSON.stringify(this.updatedTargets);
                $.ajax({
                    method: "post",
                    data: {"type": "world", "newtarget": sendbackData, "detail": ""},
                    url: "<?php echo Router::url('/', true);?>saleFigures/updatetarget",
                    success: function (data) {
                        var target = JSON.parse(data);
                        //console.log(target);
                        //return;
                        thisObj.updateData(target, thisObj.realFigure, thisObj.exchangeRate);
                        thisObj.rebuildTable();
                        alert("data has been saved successfully.");
                    },
                    error: function (e) {
                        alert('Data cannot be uploaded');
                        console.log(e);
                    }
                });
            } else {
                alert('No data to be saved.');
            }
        },
        rebuildTable: function () {
            //console.log(this.realFigure);
            var table = worldTableGenerator(this.realFigure, this.originalTarget);
            $('#datatable').empty();
            $('#datatable').append(table);
            adjustTable();
        }
    };

    function changeYear(element) {
        var requestYear = $(element).val();
        $.ajax({
            method: "post",
            data: {"startyear": requestYear},
            url: "<?php echo Router::url('/', true);?>saleFigures/world",
            success: function (data) {
                var rawData = JSON.parse(data);
                var requestYear = rawData.requestyear;
                var allFigures = rawData.data;
                var targets = rawData.target;
                var exchangeRate = rawData.exchange_rate_array;
                allTargetsData.updateData(targets, allFigures, exchangeRate);
                var table = worldTableGenerator(allFigures, targets);
                $('#datatable').empty();
                $('#datatable').append(table);
                adjustTable();
                $('#enableTableEdit').html('EDIT TABLE');
                $('#enableTableEdit').attr('data-current-status', 'disable');
                if ($('#exchangeRate').attr('data-status') != 'native') {
                    $('#exchangeRate').trigger('click');
                }
                $('#exchangeRate').attr('onclick', 'exchangeRate(this); return false;');
                $('#exchangeRate').css('opacity', '1');
                alert('This is records in ' + requestYear);
            }
        });
    }


    function adjustTable() {
        var standardWidth = jQuery(window).width();
        standardWidth = Math.round((standardWidth - 100) * 0.90 / 28);
        var padding = 3;
        var border = 1;

        var twoCellWidth = standardWidth * 2 + padding * 2 + border;
        var fourCellWidth = twoCellWidth * 2 + padding * 2 + border;
        var sixCellWidth = twoCellWidth * 3 + padding * 4 + border * 2;
        var eightCellWidth = fourCellWidth * 2 + padding * 2 + border;
        var tenCellWidth = twoCellWidth * 5 + padding * 8 + border * 4;
        var onesixCellWidth = eightCellWidth * 2 + padding * 2 + border;
        var twofourCellWidth = standardWidth * 24 + padding * 46 + border * 21;
        var threetwoCellWidth = onesixCellWidth * 2 + padding * 2 + border;

        var cellStyle = "max-width:" + standardWidth + "px;" + "min-width:" + standardWidth + "px;";
        var twocellStyle = "max-width:" + (twoCellWidth) + "px;" + "min-width:" + (twoCellWidth) + "px;";
        var fourcellStyle = "max-width:" + (fourCellWidth) + "px;" + "min-width:" + (fourCellWidth) + "px;";
        var sixcellStyle = "max-width:" + (sixCellWidth) + "px;" + "min-width:" + (sixCellWidth) + "px;";
        var eightcellStyle = "max-width:" + (eightCellWidth) + "px;" + "min-width:" + (eightCellWidth) + "px;";
        var tencellStyle = "max-width:" + (tenCellWidth) + "px;" + "min-width:" + (tenCellWidth) + "px;";
        var twofourcellStyle = "max-width:" + (twofourCellWidth) + "px;" + "min-width:" + (twofourCellWidth) + "px;";
        var threetwocellStyle = "max-width:" + (threetwoCellWidth) + "px;" + "min-width:" + (threetwoCellWidth) + "px;";

        $('.tablecell').each(function () {
            var newStyle = cellStyle;
            $(this).attr('style', newStyle);
        });
        $('.twotablecell').each(function () {
            var newStyle = twocellStyle;
            $(this).attr('style', newStyle);
        });
        $('.fourtablecell').each(function () {
            var newStyle = fourcellStyle;
            $(this).attr('style', newStyle);
        });
        $('.sixtablecell').each(function () {
            var newStyle = sixcellStyle;
            $(this).attr('style', newStyle);
        });
        $('.eighttablecell').each(function () {
            var newStyle = eightcellStyle;
            $(this).attr('style', newStyle);
        });
        $('.tentablecell').each(function () {
            var newStyle = tencellStyle;
            $(this).attr('style', newStyle);
        });
        $('.twofourtablecell').each(function () {
            var newStyle = twofourcellStyle;
            $(this).attr('style', newStyle);
        });
        $('.threetwotablecell').each(function () {
            var newStyle = threetwocellStyle;
            $(this).attr('style', newStyle);
        });
    }
    $(window).resize(function () {
        adjustTable();
    });
    $(document).ready(function () {
        adjustTable();
    });
    function worldTableGenerator(allFigures, allTargets) {
        var str = "";
        var thisYear = new Date().getFullYear();
        var thisMonth = new Date().getMonth() + 1;
        var yearKey;
        str += '<tr><td class = "twotablecell emptycell bordercell">Savoir Owned</td>'
        for (var ii = 1; ii <= 26; ii++) {
            str += '<td class = "tablecell bordercell"></td>';
        }
        str += '</tr>';
        var showroomSBCode = [1, 48, 49, 50, 3, 4, 36, 27, 24, 17, 29, 37, 34, 39];
        var monthTotal = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0, 11: 0, 12: 0};
        var monthTargetTotal = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0, 11: 0, 12: 0};
        for (var yearKey in allFigures) {
            var tempYearFigures = allFigures[yearKey];
            var tempYearTargets = allTargets[yearKey];
            var YearToDateActuralTotal = 0;
            var YearToDateTargetTotal = 0;
            var str1 = '', str2 = '', str3 = '';
            for (var showroomKey in tempYearFigures) {
                var showroomFigures = tempYearFigures[showroomKey];
                var showroomTargets = tempYearTargets[showroomKey];
                var tempStr = '';
                tempStr += '<tr><td class = "twotablecell bordercell">' + showroomFigures['showroomName'] + ' (<span class="native_currency_code" data-currency-code="' + showroomFigures['currency'] + '">' + showroomFigures['currency'] + '</span>)' + '</td>';
                var isGBP = true;
                var currencyStatus = '';
                var tempRate = 1;
                var YearToDate = 0;
                var YearToDateGBP = 0;
                var YearToDateTarget = 0;
                var YearToDateTargetGBP = 0;
                if (showroomFigures['currency'] != 'GBP') {
                    isGBP = false;
                    currencyStatus = 'nativecurrency';
                }

                for (var monthKey in showroomFigures['figures']) {
                    if (parseInt(monthKey) <=<?php echo $currentMonth;?>) {
                        if (!isGBP) {
                            tempRate = parseFloat(allTargetsData.exchangeRate[parseInt(yearKey)][parseInt(monthKey)][showroomFigures['currency']]);
                            YearToDate += showroomFigures['figures'][monthKey];
                            YearToDateGBP += showroomFigures['figures'][monthKey] / tempRate;
                            YearToDateTarget += showroomTargets[monthKey]['amount'];
                            YearToDateTargetGBP += showroomTargets[monthKey]['amount'] / tempRate;
                        } else {
                            YearToDate += showroomFigures['figures'][monthKey];
                            YearToDateGBP = YearToDate;
                            YearToDateTarget += showroomTargets[monthKey]['amount'];
                            YearToDateTargetGBP = YearToDateTarget;
                        }
                    }
                }
                YearToDateActuralTotal += YearToDateGBP;
                YearToDateTargetTotal += YearToDateTargetGBP;
                tempStr += "<td class = 'tablecell bordercell " + currencyStatus + "' data-currency-array='-1," + YearToDateTargetGBP + "," + YearToDateTarget + "'>" + YearToDateTarget.toLocaleString() + "</td>";
                tempStr += "<td class = 'tablecell bordercell " + currencyStatus + "' data-currency-array='-1," + YearToDateGBP + "," + YearToDate + "'>" + YearToDate.toLocaleString() + "</td>";
                for (var monthKey in showroomFigures['figures']) {
                    var tempMonthFigures = showroomFigures['figures'][monthKey];
                    var tempmonthTargets = showroomTargets[monthKey];
                    if (!isGBP) {
                        //console.log(showroomFigures['currency']);
                        tempRate = parseFloat(allTargetsData.exchangeRate[parseInt(yearKey)][parseInt(monthKey)][showroomFigures['currency']]);
                        var tempExchange = tempMonthFigures / tempRate;
                        monthTotal[monthKey] += tempExchange;
                        //console.log(tempMonthFigures);
                        //console.log(tempRate);
                        //console.log(tempExchange);
                    } else {
                        monthTotal[monthKey] += tempMonthFigures;
                    }
                    monthTargetTotal[monthKey] += showroomTargets[monthKey]['amount'];
                    tempStr += '<td class = "tablecell bordercell ' + currencyStatus + '" data-currency-array="' +
                            tempmonthTargets['amount'] + ',' + tempRate + '"><input class="set_target disablebg" onchange="allTargetsData.changeTarget(' +
                            yearKey + ',' + monthKey + ',' + showroomKey + ',this);return false;" type="text" value="' + tempmonthTargets['amount'].toLocaleString() + '" disabled/></td>';
                    var tep1 = parseFloat(tempMonthFigures);
                    var tep = tep1.toFixed(2);
                    if (!isGBP) {
                        tempStr += '<td class = "tablecell bordercell ' + currencyStatus + '" data-currency-array="' +
                                tep1 + ',' + tempRate + '">' + addComma(tep) + '</td>';
                    } else {
                        tempStr += '<td class = "tablecell bordercell">' + addComma(tep) + '</td>';
                    }

                }
                tempStr += '</tr>';
                if (showroomSBCode.indexOf(parseInt(showroomKey)) >= 0) {
                    str1 += tempStr;
                } else if (showroomKey == 13 || showroomKey == 14 || showroomKey == 23) {
                    str3 += tempStr;
                } else {
                    str2 += tempStr;
                }
            }
            str += str1;
            str += '<tr><td class = "twotablecell emptycell bordercell"></td>';
            for (var ii = 1; ii <= 26; ii++) {
                str += '<td class = "tablecell bordercell"></td>';
            }
            str += '</tr>';
            str += '<tr><td class = "twotablecell emptycell bordercell">Dealers</td>';
            for (var ii = 1; ii <= 26; ii++) {
                str += '<td class = "tablecell bordercell"></td>';
            }
            str += '</tr>';
            str += str2 + str3;

        }
        str += '<tr><td class = "twotablecell emptycell bordercell"></td>';
        for (var ii = 1; ii <= 26; ii++) {
            str += '<td class = "tablecell bordercell"></td>';
        }
        str += '</tr>';
        str += '<tr>';
        str += '<td class = "twotablecell bordercell">TOTAL(GBP):</td>';
        str += '<td class = "tablecell bordercell">' + YearToDateTargetTotal.toLocaleString() + "</td>";
        str += '<td class = "tablecell bordercell">' + YearToDateActuralTotal.toLocaleString() + "</td>";
        for (var ii = 1; ii <= 12; ii++) {
            str += '<td class = "tablecell bordercell">' + monthTargetTotal[ii].toLocaleString() + '</td>';
            var temp = monthTotal[ii].toFixed(2);
            str += '<td class = "tablecell bordercell">' + addComma(temp) + '</td>';
        }
        str += '</tr>';
        return str;
    }
    function addComma(digit) {
        var s = digit.toString();
        var p = s.indexOf('.');
        x = s.split('.');
        x1 = x[0];
        x2 = x.length > 1 ? '.' + x[1] : '';
        var rgx = /(\d+)(\d{3})/;
        while (rgx.test(x1)) {
            x1 = x1.replace(rgx, '$1' + ',' + '$2');
        }
        return x1 + x2;
    }
    function getMonth(monthKey) {
        var key = parseInt(monthKey);
        switch (key) {
            case 1:
                return 'JANUARY';
                break;
            case 2:
                return 'FEBRUARY';
                break;
            case 3:
                return 'MARCH';
                break;
            case 4:
                return 'APRIL';
                break;
            case 5:
                return 'MAY';
                break;
            case 6:
                return 'JUNE';
                break;
            case 7:
                return 'JULY';
                break;
            case 8:
                return 'AUGUST';
                break;
            case 9:
                return 'SEPTEMBER';
                break;
            case 10:
                return 'OCTOBER';
                break;
            case 11:
                return 'NOVEMBER';
                break;
            case 12:
                return 'DECEMBER';
                break;
        }
    }
</script>
