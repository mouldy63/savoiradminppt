<?php
require('../fpdf.php');

$month = $_GET["month"];
$year = intval($_GET["year"]);
$date = $month." / ".$year;
$lastYear = $year - 1;
$tableColumns = array(
    array(
        $date,
        "Month Actual",
        "Month Target",
        "Prior Year ($month)",
        "Prior Year to Date ($lastYear)",
        "Year to Date Target",
        "Year to Date Actual",
        "Year to Date Vs Year to Date in Sales Currency",
        "Year to Date Vs Prior Year to Date in %",
        "Year to Date Vs Year to Date Target in Sales Currency",
        "Year to Date Actual Vs Year to Date Target in %",
    )
);

$showrooms = array(
    "savoirOwned" => array(
        "Head Office (GBP)",
        "Wigmore Street (GBP)",
        "Harrods London Studio (GBP)",
        "Chelsea Harbour (GBP)",
        "Savoir Beds Wales (GBP)",
        "Düsseldorf (EUR)",
        "Paris Showroom (EUR)",
        "New York Downtown2 (USD)",
        "New York Uptown (USD)"
    ),
    "dealers" => array(
        "New York Downtown (USD)",
        "St. Petersburg (EUR)",
        "Hong Kong (GBP)",
        "Beijing (GBP) ",
        "Seoul (GBP)",
        "Shanghai (GBP)",
        "Savoir Beds Taiwan (GBP)",
        "New/ Planned (GBP)",
    ),
    "total" => array(
        "TOTAL (GBP):"
    )
);


//
//foreach($showrooms["savoirOwned"]  as $key => $val)
//{
//    echo "<pre>";
//    print_r($val . " ". $key);
//    echo "</pre>";
//}

$monthActual = array();

$actual = $_POST['monthActual'];
$monthTarget = $_POST['monthTarget'];
$priorYear = $_POST['priorYear'];
$priorYearToDate = $_POST['priorYearToDate'];
$yearToDateTarget = $_POST['yearToDateTarget'];
$yearToDateActual = $_POST['yearToDateActual'];
$YTDVsPYTDSalesCurrency = $_POST['YTDVsPYTDSalesCurrency'];
$YTDVsPYTDSalesinPercent = $_POST['YTDVsPYTDSalesinPercent'];
$YTDVsYTDTargetinSalesCurrency = $_POST['YTDVsYTDTargetinSalesCurrency'];
$YTDVsYTDTargetinPercent = $_POST['YTDVsYTDTargetinPercent'];

//landscape
$pdf = new FPDF('L', 'mm', 'A4');
$pdf->AddPage();
//}
$pdf->SetFont('Arial','B', 8);
$fontSize = 7;

$tempFontSize = $fontSize;

/**
 * @param $pdf
 * @param $cellHeight
 * @param $item
 * @param $cellWidth
 */
function tableHeader($pdf, $cellHeight, $item, $cellWidth)
{
    $pdf->Cell(30, ($cellHeight), "", 1, 0, 'C'); //adapt height to number of lines
    $pdf->Cell(250, ($cellHeight), "SAVOIR BEDS", 1, 1, 'C'); //adapt height to number of lines

    //2nd row
    $pdf->Cell(30, (5 * $cellHeight), $item[0], 1, 0, 'C'); //adapt height to number of lines
    $pdf->Cell(25, (5 * $cellHeight), $item[1], 1, 0, 'C'); //adapt height to number of lines
    //but first, because multiCell is always treated as line ending, we need to
    //manually set the xy position for the next cell to be next to it.
    //remember the x and y position before writing the multicell

    $xPos = $pdf->GetX();
    $yPos = $pdf->GetY();
    $pdf->MultiCell($cellWidth, (5 * $cellHeight), $item[2], 1, 'C');
    $pdf->SetXY($xPos + $cellWidth, $yPos);
    $xPos = $pdf->GetX();
    $yPos = $pdf->GetY();
    $pdf->MultiCell($cellWidth, (2.5 * $cellHeight), $item[3], 1, 'C');
    $pdf->SetXY($xPos + $cellWidth, $yPos);
    //return the position for the next cell to the multicell
    //and off set the x with the multicell width.
    $xPos = $pdf->GetX();
    $yPos = $pdf->GetY();
    $pdf->MultiCell($cellWidth, ((5 / 2) * $cellHeight), $item[4], 1, 'C');
    $pdf->SetXY($xPos + $cellWidth, $yPos);

    $xPos = $pdf->GetX();
    $yPos = $pdf->GetY();
    $pdf->MultiCell($cellWidth, (2.5 * $cellHeight), $item[5], 1, 'C');
    $pdf->SetXY($xPos + $cellWidth, $yPos);

    $xPos = $pdf->GetX();
    $yPos = $pdf->GetY();
    $pdf->MultiCell($cellWidth, (2.5 * $cellHeight), $item[6], 1, 'C');
    $pdf->SetXY($xPos + $cellWidth, $yPos);

    $xPos = $pdf->GetX();
    $yPos = $pdf->GetY();
    $pdf->MultiCell($cellWidth, ((5 / 3) * $cellHeight), $item[7], 1, 'C');
    $pdf->SetXY($xPos + $cellWidth, $yPos);

    $xPos = $pdf->GetX();
    $yPos = $pdf->GetY();
    $pdf->MultiCell($cellWidth, (5 / 3) * $cellHeight, $item[8], 1, 'C');
    $pdf->SetXY($xPos + $cellWidth, $yPos);

    $xPos = $pdf->GetX();
    $yPos = $pdf->GetY();
    $pdf->MultiCell($cellWidth, (5 / 4) * $cellHeight, $item[9], 1, 'C');
    $pdf->SetXY($xPos + $cellWidth, $yPos);

    $xPos = $pdf->GetX();
    $yPos = $pdf->GetY();
    $pdf->MultiCell($cellWidth, ((5 / 4) * $cellHeight), $item[10], 1, 'C');
}

foreach($tableColumns as $item){
    $cellWidth = 25;
    $cellHeight = 5;

    //check if whether if text is overflowing
    if($pdf->GetStringWidth($item[2]) < $cellWidth){
        //if not, then do nothing
        $line = 1;
    }else {
        //if it is, then calculate the height needed for wrapped cell
        //by splitting the text to fit the cell width
        //then count how many lines are needed for the text to fit the cell

        $textLength = strlen($item[2]); // total text length
        $errMargin = 10; //cell width error margin
        $startChar = 0; //character start position for each line
        $maxChar = 0; //max character in a line, to be incremented later
        $textArray = array(); //to hold the string for each line
        $tmpString = ""; //to hold the string for a line (temporary)

        while ($startChar < $textLength) { //loop until end of text
            //loop until max character reached
            while (
                $pdf->GetStringWidth($tmpString) < ($cellWidth - $errMargin) &&
                ($startChar + $maxChar) < $textLength ){
                    $maxChar++;
                    $tmpString = substr($item[2], $startChar, $maxChar);
            }
            //move startChar to next line
            $startChar = $startChar + $maxChar;
            //then add it into the array so we know how many line are needed
            array_push($textArray, $tmpString);
            //reset maxChar and tmpString
            $maxChar = 0;
            $tmpString = '';
        }
        //get Number of line
        $line = count($textArray);
    }

    //write the cells
    tableHeader($pdf, $cellHeight, $item, $cellWidth);

    //row 3
    $pdf->Cell(30,( $cellHeight), "Savoir Owned",1,0,'R');
    for($i=0; $i<9; $i++){
        $pdf->Cell($cellWidth,( $cellHeight), "",1,0);
    }
    $pdf->Cell($cellWidth,( $cellHeight), "",1,1);
    // Savoir Owned
    foreach($showrooms["savoirOwned"] as $key => $val){
        $pdf->Cell(30,( $cellHeight), $key."  ".$val,1,0,'R');
        $pdf->Cell($cellWidth,( $cellHeight), $actual,1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), $monthTarget,1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), $priorYear,1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), $priorYearToDate,1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), $yearToDateTarget,1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), $yearToDateActual,1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), $YTDVsPYTDSalesCurrency,1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), $YTDVsPYTDSalesinPercent . " %",1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), $YTDVsYTDTargetinSalesCurrency,1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), "$YTDVsYTDTargetinPercent" . " %",1,1,'R');
    }

    //blank row
    $pdf->Cell(30,( $cellHeight), "",1,0,'R');
    for($i=0; $i<9; $i++){
        $pdf->Cell($cellWidth,( $cellHeight), "",1,0);
    }
    $pdf->Cell($cellWidth,( $cellHeight), "",1,1);
    //end of blank row

    $pdf->Cell(30,( $cellHeight), "Dealers",1,0,'R');
    for($i=0; $i<9; $i++){
        $pdf->Cell($cellWidth,( $cellHeight), "",1,0);
    }
    $pdf->Cell($cellWidth,( $cellHeight), "",1,1);

    //dealers
    foreach($showrooms["dealers"] as $key => $val){
        $pdf->Cell(30,( $cellHeight), $val,1,0,'R');
        $pdf->Cell($cellWidth,( $cellHeight), $actual,1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), $monthTarget,1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), $priorYear,1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), $priorYearToDate,1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), $yearToDateTarget,1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), $yearToDateActual,1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), $YTDVsPYTDSalesCurrency,1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), $YTDVsPYTDSalesinPercent . " %",1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), $YTDVsYTDTargetinSalesCurrency,1,0, 'R');
        $pdf->Cell($cellWidth,( $cellHeight), "$YTDVsYTDTargetinPercent" . " %",1,1,'R');
    }
    //blank row
    $pdf->Cell(30,( $cellHeight), "",1,0,'R');
    for($i=0; $i<9; $i++){
        $pdf->Cell($cellWidth,( $cellHeight), "",1,0);
    }
    $pdf->Cell($cellWidth,( $cellHeight), "",1,1);

    $pdf->Cell(30,( $cellHeight), "TOTAL (GBP)",1,0,'R');
    for($i=0; $i<9; $i++){
        $pdf->Cell($cellWidth,( $cellHeight), "",1,0);
    }
    $pdf->Cell($cellWidth,( $cellHeight), "",1,1);


}

$pdf->Output();
?>