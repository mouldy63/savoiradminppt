<?php use Cake\Routing\Router; ?>

<?php if (!empty($datefrom) && !empty($dateto)) {   
	if (!array_key_exists("No. 1",$ProdLondonMattress)) $ProdLondonMattress['No. 1']=0;
	if (!array_key_exists("No. 2",$ProdLondonMattress)) $ProdLondonMattress['No. 2']=0;
	if (!array_key_exists("No. 3",$ProdLondonMattress)) $ProdLondonMattress['No. 3']=0;
	if (!array_key_exists("No. 4",$ProdLondonMattress)) $ProdLondonMattress['No. 4']=0;
	if (!array_key_exists("No. 4v",$ProdLondonMattress)) $ProdLondonMattress['No. 4v']=0;
	if (!array_key_exists("French Mattress",$ProdLondonMattress)) $ProdLondonMattress['French Mattress']=0; 
	if (!array_key_exists("State",$ProdLondonMattress)) $ProdLondonMattress['State']=0;
	
	if (!array_key_exists("No. 1",$ProdCardiffMattress)) $ProdCardiffMattress['No. 1']=0;
	if (!array_key_exists("No. 2",$ProdCardiffMattress)) $ProdCardiffMattress['No. 2']=0;
	if (!array_key_exists("No. 3",$ProdCardiffMattress)) $ProdCardiffMattress['No. 3']=0;
	if (!array_key_exists("No. 4",$ProdCardiffMattress)) $ProdCardiffMattress['No. 4']=0;
	if (!array_key_exists("No. 4v",$ProdCardiffMattress)) $ProdCardiffMattress['No. 4v']=0;
	if (!array_key_exists("French Mattress",$ProdCardiffMattress)) $ProdCardiffMattress['French Mattress']=0; 
	if (!array_key_exists("State",$ProdCardiffMattress)) $ProdCardiffMattress['State']=0; 
	
	if (!array_key_exists("No. 1",$ProdStockMattress)) $ProdStockMattress['No. 1']=0;
	if (!array_key_exists("No. 2",$ProdStockMattress)) $ProdStockMattress['No. 2']=0;
	if (!array_key_exists("No. 3",$ProdStockMattress)) $ProdStockMattress['No. 3']=0;
	if (!array_key_exists("No. 4",$ProdStockMattress)) $ProdStockMattress['No. 4']=0;
	if (!array_key_exists("No. 4v",$ProdStockMattress)) $ProdStockMattress['No. 4v']=0;
	if (!array_key_exists("French Mattress",$ProdStockMattress)) $ProdStockMattress['French Mattress']=0; 
	if (!array_key_exists("State",$ProdStockMattress)) $ProdStockMattress['State']=0; 
	
	if (!array_key_exists("No. 1",$ItemLondonMattress)) $ItemLondonMattress['No. 1']=0;
	if (!array_key_exists("No. 2",$ItemLondonMattress)) $ItemLondonMattress['No. 2']=0;
	if (!array_key_exists("No. 3",$ItemLondonMattress)) $ItemLondonMattress['No. 3']=0;
	if (!array_key_exists("No. 4",$ItemLondonMattress)) $ItemLondonMattress['No. 4']=0;
	if (!array_key_exists("No. 4v",$ItemLondonMattress)) $ItemLondonMattress['No. 4v']=0;
	if (!array_key_exists("French Mattress",$ItemLondonMattress)) $ItemLondonMattress['French Mattress']=0; 
	if (!array_key_exists("State",$ItemLondonMattress)) $ItemLondonMattress['State']=0; 

	if (!array_key_exists("No. 1",$ItemCardiffMattress)) $ItemCardiffMattress['No. 1']=0;
	if (!array_key_exists("No. 2",$ItemCardiffMattress)) $ItemCardiffMattress['No. 2']=0;
	if (!array_key_exists("No. 3",$ItemCardiffMattress)) $ItemCardiffMattress['No. 3']=0;
	if (!array_key_exists("No. 4",$ItemCardiffMattress)) $ItemCardiffMattress['No. 4']=0;
	if (!array_key_exists("No. 4v",$ItemCardiffMattress)) $ItemCardiffMattress['No. 4v']=0;
	if (!array_key_exists("French Mattress",$ItemCardiffMattress)) $ItemCardiffMattress['French Mattress']=0; 
	if (!array_key_exists("State",$ItemCardiffMattress)) $ItemCardiffMattress['State']=0; 

	if (!array_key_exists("No. 1",$ItemStockMattress)) $ItemStockMattress['No. 1']=0;
	if (!array_key_exists("No. 2",$ItemStockMattress)) $ItemStockMattress['No. 2']=0;
	if (!array_key_exists("No. 3",$ItemStockMattress)) $ItemStockMattress['No. 3']=0;
	if (!array_key_exists("No. 4",$ItemStockMattress)) $ItemStockMattress['No. 4']=0;
	if (!array_key_exists("No. 4v",$ItemStockMattress)) $ItemStockMattress['No. 4v']=0;
	if (!array_key_exists("French Mattress",$ItemStockMattress)) $ItemStockMattress['French Mattress']=0; 
	if (!array_key_exists("State",$ItemStockMattress)) $ItemStockMattress['State']=0; 

	if (!array_key_exists("No. 1",$OBLondonMattress)) $OBLondonMattress['No. 1']=0;
	if (!array_key_exists("No. 2",$OBLondonMattress)) $OBLondonMattress['No. 2']=0;
	if (!array_key_exists("No. 3",$OBLondonMattress)) $OBLondonMattress['No. 3']=0;
	if (!array_key_exists("No. 4",$OBLondonMattress)) $OBLondonMattress['No. 4']=0;
	if (!array_key_exists("No. 4v",$OBLondonMattress)) $OBLondonMattress['No. 4v']=0;
	if (!array_key_exists("French Mattress",$OBLondonMattress)) $OBLondonMattress['French Mattress']=0; 
	if (!array_key_exists("State",$OBLondonMattress)) $OBLondonMattress['State']=0; 

	if (!array_key_exists("No. 1",$OBCardiffMattress)) $OBCardiffMattress['No. 1']=0;
	if (!array_key_exists("No. 2",$OBCardiffMattress)) $OBCardiffMattress['No. 2']=0;
	if (!array_key_exists("No. 3",$OBCardiffMattress)) $OBCardiffMattress['No. 3']=0;
	if (!array_key_exists("No. 4",$OBCardiffMattress)) $OBCardiffMattress['No. 4']=0;
	if (!array_key_exists("No. 4v",$OBCardiffMattress)) $OBCardiffMattress['No. 4v']=0;
	if (!array_key_exists("French Mattress",$OBCardiffMattress)) $OBCardiffMattress['French Mattress']=0; 
	if (!array_key_exists("State",$OBCardiffMattress)) $OBCardiffMattress['State']=0; 

	if (!array_key_exists("No. 1",$OBStockMattress)) $OBStockMattress['No. 1']=0;
	if (!array_key_exists("No. 2",$OBStockMattress)) $OBStockMattress['No. 2']=0;
	if (!array_key_exists("No. 3",$OBStockMattress)) $OBStockMattress['No. 3']=0;
	if (!array_key_exists("No. 4",$OBStockMattress)) $OBStockMattress['No. 4']=0;
	if (!array_key_exists("No. 4v",$OBStockMattress)) $OBStockMattress['No. 4v']=0;
	if (!array_key_exists("French Mattress",$OBStockMattress)) $OBStockMattress['French Mattress']=0; 
	if (!array_key_exists("State",$OBStockMattress)) $OBStockMattress['State']=0; 
	
	if (!array_key_exists("No. 1",$ProdLondonBase)) $ProdLondonBase['No. 1']=0;
	if (!array_key_exists("No. 2",$ProdLondonBase)) $ProdLondonBase['No. 2']=0;
	if (!array_key_exists("No. 3",$ProdLondonBase)) $ProdLondonBase['No. 3']=0;
	if (!array_key_exists("No. 4",$ProdLondonBase)) $ProdLondonBase['No. 4']=0;
	if (!array_key_exists("No. 4v",$ProdLondonBase)) $ProdLondonBase['No. 4v']=0;
	if (!array_key_exists("Pegboard",$ProdLondonBase)) $ProdLondonBase['Pegboard']=0;
	if (!array_key_exists("Platform Base",$ProdLondonBase)) $ProdLondonBase['Platform Base']=0;
	if (!array_key_exists("Savoir Slim",$ProdLondonBase)) $ProdLondonBase['Savoir Slim']=0; 
	if (!array_key_exists("State",$ProdLondonBase)) $ProdLondonBase['State']=0;

	if (!array_key_exists("No. 1",$ProdCardiffBase)) $ProdCardiffBase['No. 1']=0;
	if (!array_key_exists("No. 2",$ProdCardiffBase)) $ProdCardiffBase['No. 2']=0;
	if (!array_key_exists("No. 3",$ProdCardiffBase)) $ProdCardiffBase['No. 3']=0;
	if (!array_key_exists("No. 4",$ProdCardiffBase)) $ProdCardiffBase['No. 4']=0;
	if (!array_key_exists("No. 4v",$ProdCardiffBase)) $ProdCardiffBase['No. 4v']=0;
	if (!array_key_exists("Pegboard",$ProdCardiffBase)) $ProdCardiffBase['Pegboard']=0;
	if (!array_key_exists("Platform Base",$ProdCardiffBase)) $ProdCardiffBase['Platform Base']=0;
	if (!array_key_exists("Savoir Slim",$ProdCardiffBase)) $ProdCardiffBase['Savoir Slim']=0; 
	if (!array_key_exists("State",$ProdCardiffBase)) $ProdCardiffBase['State']=0;
	
	if (!array_key_exists("No. 1",$ProdStockBase)) $ProdStockBase['No. 1']=0;
	if (!array_key_exists("No. 2",$ProdStockBase)) $ProdStockBase['No. 2']=0;
	if (!array_key_exists("No. 3",$ProdStockBase)) $ProdStockBase['No. 3']=0;
	if (!array_key_exists("No. 4",$ProdStockBase)) $ProdStockBase['No. 4']=0;
	if (!array_key_exists("No. 4v",$ProdStockBase)) $ProdStockBase['No. 4v']=0;
	if (!array_key_exists("Pegboard",$ProdStockBase)) $ProdStockBase['Pegboard']=0;
	if (!array_key_exists("Platform Base",$ProdStockBase)) $ProdStockBase['Platform Base']=0;
	if (!array_key_exists("Savoir Slim",$ProdStockBase)) $ProdStockBase['Savoir Slim']=0; 
	if (!array_key_exists("State",$ProdStockBase)) $ProdStockBase['State']=0;
	
	if (!array_key_exists("No. 1",$ItemLondonBase)) $ItemLondonBase['No. 1']=0;
	if (!array_key_exists("No. 2",$ItemLondonBase)) $ItemLondonBase['No. 2']=0;
	if (!array_key_exists("No. 3",$ItemLondonBase)) $ItemLondonBase['No. 3']=0;
	if (!array_key_exists("No. 4",$ItemLondonBase)) $ItemLondonBase['No. 4']=0;
	if (!array_key_exists("No. 4v",$ItemLondonBase)) $ItemLondonBase['No. 4v']=0;
	if (!array_key_exists("Pegboard",$ItemLondonBase)) $ItemLondonBase['Pegboard']=0;
	if (!array_key_exists("Platform Base",$ItemLondonBase)) $ItemLondonBase['Platform Base']=0;
	if (!array_key_exists("Savoir Slim",$ItemLondonBase)) $ItemLondonBase['Savoir Slim']=0; 
	if (!array_key_exists("State",$ItemLondonBase)) $ItemLondonBase['State']=0;

	if (!array_key_exists("No. 1",$ItemCardiffBase)) $ItemCardiffBase['No. 1']=0;
	if (!array_key_exists("No. 2",$ItemCardiffBase)) $ItemCardiffBase['No. 2']=0;
	if (!array_key_exists("No. 3",$ItemCardiffBase)) $ItemCardiffBase['No. 3']=0;
	if (!array_key_exists("No. 4",$ItemCardiffBase)) $ItemCardiffBase['No. 4']=0;
	if (!array_key_exists("No. 4v",$ItemCardiffBase)) $ItemCardiffBase['No. 4v']=0;
	if (!array_key_exists("Pegboard",$ItemCardiffBase)) $ItemCardiffBase['Pegboard']=0;
	if (!array_key_exists("Platform Base",$ItemCardiffBase)) $ItemCardiffBase['Platform Base']=0;
	if (!array_key_exists("Savoir Slim",$ItemCardiffBase)) $ItemCardiffBase['Savoir Slim']=0; 
	if (!array_key_exists("State",$ItemCardiffBase)) $ItemCardiffBase['State']=0;
	
	if (!array_key_exists("No. 1",$ItemStockBase)) $ItemStockBase['No. 1']=0;
	if (!array_key_exists("No. 2",$ItemStockBase)) $ItemStockBase['No. 2']=0;
	if (!array_key_exists("No. 3",$ItemStockBase)) $ItemStockBase['No. 3']=0;
	if (!array_key_exists("No. 4",$ItemStockBase)) $ItemStockBase['No. 4']=0;
	if (!array_key_exists("No. 4v",$ItemStockBase)) $ItemStockBase['No. 4v']=0;
	if (!array_key_exists("Pegboard",$ItemStockBase)) $ItemStockBase['Pegboard']=0;
	if (!array_key_exists("Platform Base",$ItemStockBase)) $ItemStockBase['Platform Base']=0;
	if (!array_key_exists("Savoir Slim",$ItemStockBase)) $ItemStockBase['Savoir Slim']=0; 
	if (!array_key_exists("State",$ItemStockBase)) $ItemStockBase['State']=0;
	
	if (!array_key_exists("No. 1",$OBLondonBase)) $OBLondonBase['No. 1']=0;
	if (!array_key_exists("No. 2",$OBLondonBase)) $OBLondonBase['No. 2']=0;
	if (!array_key_exists("No. 3",$OBLondonBase)) $OBLondonBase['No. 3']=0;
	if (!array_key_exists("No. 4",$OBLondonBase)) $OBLondonBase['No. 4']=0;
	if (!array_key_exists("No. 4v",$OBLondonBase)) $OBLondonBase['No. 4v']=0;
	if (!array_key_exists("Pegboard",$OBLondonBase)) $OBLondonBase['Pegboard']=0;
	if (!array_key_exists("Platform Base",$OBLondonBase)) $OBLondonBase['Platform Base']=0;
	if (!array_key_exists("Savoir Slim",$OBLondonBase)) $OBLondonBase['Savoir Slim']=0; 
	if (!array_key_exists("State",$OBLondonBase)) $OBLondonBase['State']=0;

	if (!array_key_exists("No. 1",$OBCardiffBase)) $OBCardiffBase['No. 1']=0;
	if (!array_key_exists("No. 2",$OBCardiffBase)) $OBCardiffBase['No. 2']=0;
	if (!array_key_exists("No. 3",$OBCardiffBase)) $OBCardiffBase['No. 3']=0;
	if (!array_key_exists("No. 4",$OBCardiffBase)) $OBCardiffBase['No. 4']=0;
	if (!array_key_exists("No. 4v",$OBCardiffBase)) $OBCardiffBase['No. 4v']=0;
	if (!array_key_exists("Pegboard",$OBCardiffBase)) $OBCardiffBase['Pegboard']=0;
	if (!array_key_exists("Platform Base",$OBCardiffBase)) $OBCardiffBase['Platform Base']=0;
	if (!array_key_exists("Savoir Slim",$OBCardiffBase)) $OBCardiffBase['Savoir Slim']=0; 
	if (!array_key_exists("State",$OBCardiffBase)) $OBCardiffBase['State']=0;
	
	if (!array_key_exists("No. 1",$OBStockBase)) $OBStockBase['No. 1']=0;
	if (!array_key_exists("No. 2",$OBStockBase)) $OBStockBase['No. 2']=0;
	if (!array_key_exists("No. 3",$OBStockBase)) $OBStockBase['No. 3']=0;
	if (!array_key_exists("No. 4",$OBStockBase)) $OBStockBase['No. 4']=0;
	if (!array_key_exists("No. 4v",$OBStockBase)) $OBStockBase['No. 4v']=0;
	if (!array_key_exists("Pegboard",$OBStockBase)) $OBStockBase['Pegboard']=0;
	if (!array_key_exists("Platform Base",$OBStockBase)) $OBStockBase['Platform Base']=0;
	if (!array_key_exists("Savoir Slim",$OBStockBase)) $OBStockBase['Savoir Slim']=0; 
	if (!array_key_exists("State",$OBStockBase)) $OBStockBase['State']=0;

	if (!array_key_exists("HCa Topper",$ProdLondonTopper)) $ProdLondonTopper['HCa Topper']=0;
	if (!array_key_exists("HW Topper",$ProdLondonTopper)) $ProdLondonTopper['HW Topper']=0;
	if (!array_key_exists("CW Topper",$ProdLondonTopper)) $ProdLondonTopper['CW Topper']=0;
	if (!array_key_exists("CFv Topper",$ProdLondonTopper)) $ProdLondonTopper['CFv Topper']=0;
	
	if (!array_key_exists("HCa Topper",$ProdCardiffTopper)) $ProdCardiffTopper['HCa Topper']=0;
	if (!array_key_exists("HW Topper",$ProdCardiffTopper)) $ProdCardiffTopper['HW Topper']=0;
	if (!array_key_exists("CW Topper",$ProdCardiffTopper)) $ProdCardiffTopper['CW Topper']=0;
	if (!array_key_exists("CFv Topper",$ProdCardiffTopper)) $ProdCardiffTopper['CFv Topper']=0;
	
	if (!array_key_exists("HCa Topper",$ProdStockTopper)) $ProdStockTopper['HCa Topper']=0;
	if (!array_key_exists("HW Topper",$ProdStockTopper)) $ProdStockTopper['HW Topper']=0;
	if (!array_key_exists("CW Topper",$ProdStockTopper)) $ProdStockTopper['CW Topper']=0;
	if (!array_key_exists("CFv Topper ",$ProdStockTopper)) $ProdStockTopper['CFv Topper']=0;
	
	if (!array_key_exists("HCa Topper",$ItemLondonTopper)) $ItemLondonTopper['HCa Topper']=0;
	if (!array_key_exists("HW Topper",$ItemLondonTopper)) $ItemLondonTopper['HW Topper']=0;
	if (!array_key_exists("CW Topper",$ItemLondonTopper)) $ItemLondonTopper['CW Topper']=0;
	if (!array_key_exists("CFv Topper",$ItemLondonTopper)) $ItemLondonTopper['CFv Topper']=0;
	
	if (!array_key_exists("HCa Topper",$ItemCardiffTopper)) $ItemCardiffTopper['HCa Topper']=0;
	if (!array_key_exists("HW Topper",$ItemCardiffTopper)) $ItemCardiffTopper['HW Topper']=0;
	if (!array_key_exists("CW Topper",$ItemCardiffTopper)) $ItemCardiffTopper['CW Topper']=0;
	if (!array_key_exists("CFv Topper",$ItemCardiffTopper)) $ItemCardiffTopper['CFv Topper']=0;
	
	if (!array_key_exists("HCa Topper",$ItemStockTopper)) $ItemStockTopper['HCa Topper']=0;
	if (!array_key_exists("HW Topper",$ItemStockTopper)) $ItemStockTopper['HW Topper']=0;
	if (!array_key_exists("CW Topper",$ItemStockTopper)) $ItemStockTopper['CW Topper']=0;
	if (!array_key_exists("CFv Topper",$ItemStockTopper)) $ItemStockTopper['CFv Topper']=0;
	
	if (!array_key_exists("HCa Topper",$OBLondonTopper)) $OBLondonTopper['HCa Topper']=0;
	if (!array_key_exists("HCa Topper",$OBCardiffTopper)) $OBCardiffTopper['HCa Topper']=0;
	if (!array_key_exists("HCa Topper",$OBStockTopper)) $OBStockTopper['HCa Topper']=0;
	
	if (!array_key_exists("HW Topper",$OBLondonTopper)) $OBLondonTopper['HW Topper']=0;
	if (!array_key_exists("HW Topper",$OBCardiffTopper)) $OBCardiffTopper['HW Topper']=0;
	if (!array_key_exists("HW Topper",$OBStockTopper)) $OBStockTopper['HW Topper']=0;
	
	if (!array_key_exists("CW Topper",$OBLondonTopper)) $OBLondonTopper['CW Topper']=0;
	if (!array_key_exists("CW Topper",$OBCardiffTopper)) $OBCardiffTopper['CW Topper']=0;
	if (!array_key_exists("CW Topper",$OBStockTopper)) $OBStockTopper['CW Topper']=0;

	if (!array_key_exists("CFv Topper",$OBLondonTopper)) $OBLondonTopper['CFv Topper']=0;
	if (!array_key_exists("CFv Topper",$OBCardiffTopper)) $OBCardiffTopper['CFv Topper']=0;
	if (!array_key_exists("CFv Topper",$OBStockTopper)) $OBStockTopper['CFv Topper']=0;
	
	if (!array_key_exists("HCa Topper",$ProdLondonTopperOnly)) $ProdLondonTopperOnly['HCa Topper']=0;
	if (!array_key_exists("HW Topper",$ProdLondonTopperOnly)) $ProdLondonTopperOnly['HW Topper']=0;
	if (!array_key_exists("CW Topper",$ProdLondonTopperOnly)) $ProdLondonTopperOnly['CW Topper']=0;
	if (!array_key_exists("CFv Topper",$ProdLondonTopperOnly)) $ProdLondonTopperOnly['CFv Topper']=0;
	
	if (!array_key_exists("HCa Topper",$ProdCardiffTopperOnly)) $ProdCardiffTopperOnly['HCa Topper']=0;
	if (!array_key_exists("HW Topper",$ProdCardiffTopperOnly)) $ProdCardiffTopperOnly['HW Topper']=0;
	if (!array_key_exists("CW Topper",$ProdCardiffTopperOnly)) $ProdCardiffTopperOnly['CW Topper']=0;
	if (!array_key_exists("CFv Topper",$ProdCardiffTopperOnly)) $ProdCardiffTopperOnly['CFv Topper']=0;
	
	if (!array_key_exists("HCa Topper",$ProdStockTopperOnly)) $ProdStockTopperOnly['HCa Topper']=0;
	if (!array_key_exists("HW Topper",$ProdStockTopperOnly)) $ProdStockTopperOnly['HW Topper']=0;
	if (!array_key_exists("CW Topper",$ProdStockTopperOnly)) $ProdStockTopperOnly['CW Topper']=0;
	if (!array_key_exists("CFv Topper",$ProdStockTopperOnly)) $ProdStockTopperOnly['CFv Topper']=0;
	
	if (!array_key_exists("HCa Topper",$ItemLondonTopperOnly)) $ItemLondonTopperOnly['HCa Topper']=0;
	if (!array_key_exists("HW Topper",$ItemLondonTopperOnly)) $ItemLondonTopperOnly['HW Topper']=0;
	if (!array_key_exists("CW Topper",$ItemLondonTopperOnly)) $ItemLondonTopperOnly['CW Topper']=0;
	if (!array_key_exists("CFv Topper",$ItemLondonTopperOnly)) $ItemLondonTopperOnly['CFv Topper']=0;
	
	if (!array_key_exists("HCa Topper",$ItemCardiffTopperOnly)) $ItemCardiffTopperOnly['HCa Topper']=0;
	if (!array_key_exists("HW Topper",$ItemCardiffTopperOnly)) $ItemCardiffTopperOnly['HW Topper']=0;
	if (!array_key_exists("CW Topper",$ItemCardiffTopperOnly)) $ItemCardiffTopperOnly['CW Topper']=0;
	if (!array_key_exists("CFv Topper",$ItemCardiffTopperOnly)) $ItemCardiffTopperOnly['CFv Topper']=0;
	
	if (!array_key_exists("HCa Topper",$ItemStockTopperOnly)) $ItemStockTopperOnly['HCa Topper']=0;
	if (!array_key_exists("HW Topper",$ItemStockTopperOnly)) $ItemStockTopperOnly['HW Topper']=0;
	if (!array_key_exists("CW Topper",$ItemStockTopperOnly)) $ItemStockTopperOnly['CW Topper']=0;
	if (!array_key_exists("CFv Topper",$ItemStockTopperOnly)) $ItemStockTopperOnly['CFv Topper']=0;
	
	if (!array_key_exists("HCa Topper",$OBLondonTopperOnly)) $OBLondonTopperOnly['HCa Topper']=0;
	if (!array_key_exists("HCa Topper",$OBCardiffTopperOnly)) $OBCardiffTopperOnly['HCa Topper']=0;
	if (!array_key_exists("HCa Topper",$OBStockTopperOnly)) $OBStockTopperOnly['HCa Topper']=0;
	
	if (!array_key_exists("HW Topper",$OBLondonTopperOnly)) $OBLondonTopperOnly['HW Topper']=0;
	if (!array_key_exists("HW Topper",$OBCardiffTopperOnly)) $OBCardiffTopperOnly['HW Topper']=0;
	if (!array_key_exists("HW Topper",$OBStockTopperOnly)) $OBStockTopperOnly['HW Topper']=0;
	
	if (!array_key_exists("CW Topper",$OBLondonTopperOnly)) $OBLondonTopperOnly['CW Topper']=0;
	if (!array_key_exists("CW Topper",$OBCardiffTopperOnly)) $OBCardiffTopperOnly['CW Topper']=0;
	if (!array_key_exists("CW Topper",$OBStockTopperOnly)) $OBStockTopperOnly['CW Topper']=0;
	
	if (!array_key_exists("CFv Topper",$OBLondonTopperOnly)) $OBLondonTopperOnly['CFv Topper']=0;
	if (!array_key_exists("CFv Topper",$OBCardiffTopperOnly)) $OBCardiffTopperOnly['CFv Topper']=0;
	if (!array_key_exists("CFv Topper",$OBStockTopperOnly)) $OBStockTopperOnly['CFv Topper']=0;
	
	
} else {
$datefrom='';
$dateto='';
} ?>
<script>
$(function() {
var year = new Date().getFullYear();
$( "#datefrom" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#datefrom" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#dateto" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy'

});
$( "#dateto" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});

</script>

<div class="container">
<div class="content brochure">
			    <div class="one-col head-col">
    		<form name="form1" method="post" action="/php/itemsproduced">
    		
    		<table width="530" border="1" cellspacing="2" cellpadding="1" align="right">
              <tr>
                <td colspan="2" rowspan="2" valign="bottom">No of Items Produced in Week</td>
                <td colspan="5">Production Screen Schedule Days from Production complete</td>
              </tr>
              <tr>
                <td align="left" valign="bottom">Woodwork</td>
                <td align="left" valign="bottom">Cutting Room</td>
                <td align="left" valign="bottom">Production Floor</td>
				<td align="left" valign="bottom">Spring Completion</td>
				<td align="left" valign="bottom">Leg Completion</td>
              </tr>
              <tr>
                <td width="63">London</td>
                <td><label for="alondonNo"></label>
                <input name="alondonNo" type="text" id="alondonNo" size="5" value="<?php echo $LondonItemsProduced['NoItemsWeek']; ?>"></td>
                <td align="left"><input name="londonNoW" type="text" id="londonNoW" size="5" value="<?php echo $LondonItemsProduced['WoodworkNoItems']; ?>">
                days <a href="/deliveriesbookedwoodwork.asp?madeat=2">VIEW</a></td>
                <td align="left"><input name="londonNoCR" type="text" id="londonNoCR" size="5" value="<?php echo $LondonItemsProduced['CuttingRoomNoItems']; ?>">
                days <a href="/deliveriesbookedcuttingroom.asp?madeat=2">VIEW</a></td>
                <td align="left"><input name="londonNoPF" type="text" id="londonNoPF" size="5" value="<?php echo $LondonItemsProduced['ProductionFloorNoItems']; ?>">
                days <a href="/deliveriesbooked1.asp?madeat=2">VIEW</a></td>
                <td align="left"><input name="londonNoSC" type="text" id="londonNoSC" size="5" value="<?php echo $LondonItemsProduced['SpringCompletionNoItems']; ?>">
                days <a href="/deliveriesbooked1.asp?madeat=2">VIEW</a></td>
                <td align="left"><input name="londonNoLC" type="text" id="londonNoLC" size="5" value="<?php echo $LondonItemsProduced['LegCompletionNoItems']; ?>">
                days <a href="/deliveriesbooked1.asp?madeat=2">VIEW</a></td>
              </tr>
              <tr>
                <td>Cardiff</td>
                <td width="82"><input name="acardiffNo" type="text" id="acardiffNo" size="5" value="<?php echo $CardiffItemsProduced['NoItemsWeek']; ?>"></td>
                <td width="114" align="left"><input name="cardiffNoW" type="text" id="cardiffNoW" size="5" value="<?php echo $CardiffItemsProduced['WoodworkNoItems']; ?>">
                days <a href="/deliveriesbookedwoodwork.asp?madeat=1">VIEW</a></td>
                <td width="113" align="left"><input name="cardiffNoCR" type="text" id="cardiffNoCR" size="5" value="<?php echo $CardiffItemsProduced['CuttingRoomNoItems']; ?>">
                days <a href="/deliveriesbookedcuttingroom.asp?madeat=1">VIEW</a></td>
                <td width="106" align="left"><input name="cardiffNoPF" type="text" id="cardiffNoPF" size="5" value="<?php echo $CardiffItemsProduced['ProductionFloorNoItems']; ?>">
                days <a href="/deliveriesbooked1.asp?madeat=1">VIEW</a></td>
                <td width="106" align="left"><input name="cardiffNoSC" type="text" id="cardiffNoSC" size="5" value="<?php echo $CardiffItemsProduced['SpringCompletionNoItems']; ?>">
				days <a href="/deliveriesbooked1.asp?madeat=1">VIEW</a></td>
                
              </tr>
            </table>
            <table width="400" border="0" align="center" cellpadding="5" cellspacing="2">
					    <tr>
					      <td><strong>Completed date from :</strong><br>
		  <input name="datefrom" type="text" class="text" id="datefrom" size="10" value="<?= $datefrom ?>" />
					     </td>
					      <td><strong>Completed date to: </strong><br>
                          <input name="dateto" type="text" class="text" id="dateto" size="10" value="<?= $dateto ?>" /></td>
				        </tr>
                      
					    <tr>
					      <td colspan="2" align="left">				          <span class="row">
					        <input type="submit" name="submit" value="Search Database or Update Items per week"  id="submit" class="button" />
					      </span></td>
	      </tr>
			      </table>
            </form>
<?php if (!empty($datefrom) && !empty($dateto)) {  ?>  
<p>Production Items Produced Report</p>
          <p>Dates: From <?= $datefrom ?> to <?= $dateto ?><br>
          </p>
       
<table border="0" cellspacing="3" cellpadding="3">
  <tr>
    <td>&nbsp;</td>
    <td colspan="2" align="left" bgcolor="#FFFFFF"><strong>Orders produced</strong>      <br>
      <br>      <strong>Production complete is not null</strong></td>
    <td align="left">&nbsp;</td>
    <td colspan="2" align="left" bgcolor="#FFFFFF"><strong>Items produced</strong>      <br>
      <br>      <strong>Finished date is not null</strong></td>
    <td align="left">&nbsp;</td>
    <td colspan="2" align="left" bgcolor="#FFFFFF"><strong>Order Book</strong>      <br>
      <br>      <strong>Finished date is null</strong></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><strong>London</strong></td>
    <td bgcolor="#FFFFFF"><strong>Cardiff</strong></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><strong>London</strong></td>
    <td bgcolor="#FFFFFF"><strong>Cardiff</strong></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><strong><a href="/php/ItemsProduced/exportOBdetail?comp=3&type=prod&madeat=2">London</a></strong></td>
    <td bgcolor="#FFFFFF"><strong><a href="/php/ItemsProduced/exportOBdetail?comp=3&type=prod&madeat=1">Cardiff</a></strong></td>
    </tr>
  <tr>
    <td><strong>Mattresses</strong></td>
    <td bgcolor="#FFFFFF">
     <form action="/php/itemsproduced/export" method="post" name="form2">
    <input id="comp" name="comp" type="hidden" value="1">
    <input id="type" name="type" type="hidden" value="prod">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form></td>
    <td bgcolor="#FFFFFF">
    <form action="/php/itemsproduced/export" method="post" name="form2">
    <input id="comp" name="comp" type="hidden" value="1">
    <input id="type" name="type" type="hidden" value="prod">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">
    <form action="/php/itemsproduced/export" method="post" name="form2">
    <input id="comp" name="comp" type="hidden" value="1">
    <input id="type" name="type" type="hidden" value="item">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
   </td>
    <td bgcolor="#FFFFFF">
    <form action="/php/itemsproduced/export" method="post" name="form2">
    <input id="comp" name="comp" type="hidden" value="1">
    <input id="type" name="type" type="hidden" value="item">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
   </td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">
    <form action="/php/itemsproduced/export" method="post" name="form2">
    <input id="comp" name="comp" type="hidden" value="1">
    <input id="type" name="type" type="hidden" value="OB">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
    </td>
    <td bgcolor="#FFFFFF">
    <form action="/php/itemsproduced/export" method="post" name="form2">
    <input id="comp" name="comp" type="hidden" value="1">
    <input id="type" name="type" type="hidden" value="OB">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
    </td>
    </tr>
  <tr>
    <td>No. 1</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonMattress['No. 1']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffMattress['No. 1']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonMattress['No. 1']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffMattress['No. 1']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonMattress['No. 1']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffMattress['No. 1']; ?></td>
    </tr>    
    <tr>
    <td>No. 2</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonMattress['No. 2']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffMattress['No. 2']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonMattress['No. 2']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffMattress['No. 2']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonMattress['No. 2']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffMattress['No. 2']; ?></td>
    </tr>
    <tr>
    <td>No. 3</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonMattress['No. 3']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffMattress['No. 3']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonMattress['No. 3']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffMattress['No. 3']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonMattress['No. 3']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffMattress['No. 3']; ?></td>
    </tr>  
    <tr>
    <td>No. 4</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonMattress['No. 4']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffMattress['No. 4']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonMattress['No. 4']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffMattress['No. 4']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonMattress['No. 4']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffMattress['No. 4']; ?></td>
    </tr> 
    <tr>
    <td>No. 4v</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonMattress['No. 4v']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffMattress['No. 4v']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonMattress['No. 4v']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffMattress['No. 4v']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonMattress['No. 4v']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffMattress['No. 4v']; ?></td>
    </tr>   
    <td>French Mattress</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonMattress['French Mattress']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffMattress['French Mattress']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonMattress['French Mattress']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffMattress['French Mattress']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonMattress['French Mattress']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffMattress['French Mattress']; ?></td>
    </tr>  
    <tr>     
    <td>State</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonMattress['State']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffMattress['State']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonMattress['State']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffMattress['State']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonMattress['State']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffMattress['State']; ?></td>
    </tr> 
    <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr> 
    <tr>
    <td><strong>Box Springs</strong></td>
        <td bgcolor="#FFFFFF">
        <form action="/php/itemsproduced/export" method="post" name="form2">
    <input id="comp" name="comp" type="hidden" value="3">
    <input id="type" name="type" type="hidden" value="prod">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
  </td>
    <td bgcolor="#FFFFFF">
     <form action="/php/itemsproduced/export" method="post" name="form2">
    <input id="comp" name="comp" type="hidden" value="3">
    <input id="type" name="type" type="hidden" value="prod">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
    </td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">
    <form action="/php/itemsproduced/export" method="post" name="form2">
    <input id="comp" name="comp" type="hidden" value="3">
    <input id="type" name="type" type="hidden" value="item">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
    </td>
    <td bgcolor="#FFFFFF">
    <form action="/php/itemsproduced/export" method="post" name="form2">
    <input id="comp" name="comp" type="hidden" value="3">
    <input id="type" name="type" type="hidden" value="item">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
  </td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">
    <form action="/php/itemsproduced/export" method="post" name="form2">
    <input id="comp" name="comp" type="hidden" value="3">
    <input id="type" name="type" type="hidden" value="OB">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
   </td>
    <td bgcolor="#FFFFFF">
    <form action="/php/itemsproduced/export" method="post" name="form2">
    <input id="comp" name="comp" type="hidden" value="3">
    <input id="type" name="type" type="hidden" value="OB">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
    </td>
    </tr>
  <tr>
    <td>No. 1</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonBase['No. 1']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffBase['No. 1']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonBase['No. 1']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffBase['No. 1']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonBase['No. 1']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffBase['No. 1']; ?></td>
    </tr>
  <tr>
    <td>No. 2</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonBase['No. 2']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffBase['No. 2']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonBase['No. 2']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffBase['No. 2']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonBase['No. 2']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffBase['No. 2']; ?></td>
    </tr>
  <tr>
    <td>No. 3</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonBase['No. 3']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffBase['No. 3']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonBase['No. 3']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffBase['No. 3']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonBase['No. 3']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffBase['No. 3']; ?></td>
    </tr>
  <tr>
    <td>No. 4</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonBase['No. 4']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffBase['No. 4']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonBase['No. 4']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffBase['No. 4']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonBase['No. 4']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffBase['No. 4']; ?></td>
    </tr>
  <tr>
    <td>No. 4v</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonBase['No. 4v']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffBase['No. 4v']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonBase['No. 4v']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffBase['No. 4v']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonBase['No. 4v']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffBase['No. 4v']; ?></td>
    </tr>
  <tr>
    <td>Pegboard</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonBase['Pegboard']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffBase['Pegboard']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonBase['Pegboard']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffBase['Pegboard']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonBase['Pegboard']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffBase['Pegboard']; ?></td>
    </tr>
  <tr>
    <td>Platform</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonBase['Platform Base']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffBase['Platform Base']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonBase['Platform Base']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffBase['Platform Base']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonBase['Platform Base']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffBase['Platform Base']; ?></td>
    </tr>
  <tr>
    <td>Savoir Slim</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonBase['Savoir Slim']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffBase['Savoir Slim']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonBase['Savoir Slim']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffBase['Savoir Slim']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonBase['Savoir Slim']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffBase['Savoir Slim']; ?></td>
    </tr>
  <tr>
    <td>State</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonBase['State']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffBase['State']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonBase['State']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffBase['State']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonBase['State']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffBase['State']; ?></td>
    </tr> 
    <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr> 
  <td><strong>Toppers Linked with mattress or base</strong></td>
   <td bgcolor="#FFFFFF">
   <form action="/php/itemsproduced/exporttopper" method="post" name="form2">
    <input id="incexc" name="incexc" type="hidden" value="inc">
    <input id="type" name="type" type="hidden" value="prod">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
    </td>
    <td bgcolor="#FFFFFF">
     <form action="/php/itemsproduced/exporttopper" method="post" name="form2">
    <input id="incexc" name="incexc" type="hidden" value="inc">
    <input id="type" name="type" type="hidden" value="prod">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
   </td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">
     <form action="/php/itemsproduced/exporttopper" method="post" name="form2">
    <input id="incexc" name="incexc" type="hidden" value="inc">
    <input id="type" name="type" type="hidden" value="item">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
   </td>
    <td bgcolor="#FFFFFF">
    <form action="/php/itemsproduced/exporttopper" method="post" name="form2">
    <input id="incexc" name="incexc" type="hidden" value="inc">
    <input id="type" name="type" type="hidden" value="item">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
   </td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">
    <form action="/php/itemsproduced/exporttopper" method="post" name="form2">
    <input id="incexc" name="incexc" type="hidden" value="inc">
    <input id="type" name="type" type="hidden" value="OB">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
   </td>
    <td bgcolor="#FFFFFF">
    <form action="/php/itemsproduced/exporttopper" method="post" name="form2">
    <input id="incexc" name="incexc" type="hidden" value="inc">
    <input id="type" name="type" type="hidden" value="OB">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
  </td>
    </tr>
  <tr>
    <td>HCA</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonTopper['HCa Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffTopper['HCa Topper']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonTopper['HCa Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffTopper['HCa Topper']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonTopper['HCa Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffTopper['HCa Topper']; ?></td>
    </tr>
  <tr>
    <td>HW</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonTopper['HW Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffTopper['HW Topper']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonTopper['HW Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffTopper['HW Topper']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonTopper['HW Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffTopper['HW Topper']; ?></td>
    </tr>
  <tr>
    <td>CW</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonTopper['CW Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffTopper['CW Topper']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonTopper['CW Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffTopper['CW Topper']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonTopper['CW Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffTopper['CW Topper']; ?></td>
  </tr> 
  <tr>
    <td>CFv</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonTopper['CFv Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffTopper['CFv Topper']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonTopper['CFv Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffTopper['CFv Topper']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonTopper['CFv Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffTopper['CFv Topper']; ?></td>
  </tr> 
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
   <tr>
<td><strong>Toppers only (no base or mattress)</strong></td>
    <td bgcolor="#FFFFFF">
    <form action="/php/itemsproduced/exporttopper" method="post" name="form2">
    <input id="incexc" name="incexc" type="hidden" value="exc">
    <input id="type" name="type" type="hidden" value="prod">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form> </td>
    <td bgcolor="#FFFFFF">
    <form action="/php/itemsproduced/exporttopper" method="post" name="form2">
    <input id="incexc" name="incexc" type="hidden" value="exc">
    <input id="type" name="type" type="hidden" value="prod">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
    </td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">
    <form action="/php/itemsproduced/exporttopper" method="post" name="form2">
    <input id="incexc" name="incexc" type="hidden" value="exc">
    <input id="type" name="type" type="hidden" value="item">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form></td>
    <td bgcolor="#FFFFFF">
     <form action="/php/itemsproduced/exporttopper" method="post" name="form2">
    <input id="incexc" name="incexc" type="hidden" value="exc">
    <input id="type" name="type" type="hidden" value="item">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">
    <form action="/php/itemsproduced/exporttopper" method="post" name="form2">
    <input id="incexc" name="incexc" type="hidden" value="exc">
    <input id="type" name="type" type="hidden" value="OB">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
   </td>
    <td bgcolor="#FFFFFF">
    <form action="/php/itemsproduced/exporttopper" method="post" name="form2">
    <input id="incexc" name="incexc" type="hidden" value="exc">
    <input id="type" name="type" type="hidden" value="OB">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form></td>
    </tr>
  <tr>
    <td>HCA</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonTopperOnly['HCa Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffTopperOnly['HCa Topper']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonTopperOnly['HCa Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffTopperOnly['HCa Topper']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonTopperOnly['HCa Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffTopperOnly['HCa Topper']; ?></td>
    </tr>
  <tr>
    <td>HW</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonTopperOnly['HW Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffTopperOnly['HW Topper']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonTopperOnly['HW Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffTopperOnly['HW Topper']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonTopperOnly['HW Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffTopperOnly['HW Topper']; ?></td>
    </tr>
  <tr>
    <td>CW</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonTopperOnly['CW Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffTopperOnly['CW Topper']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonTopperOnly['CW Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffTopperOnly['CW Topper']; ?></td>
    <td>&nbsp;</td>
     <td bgcolor="#FFFFFF"><?= $OBLondonTopperOnly['CW Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffTopperOnly['CW Topper']; ?></td>
 </tr>
 <tr>
    <td>CFv</td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonTopperOnly['CFv Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffTopperOnly['CFv Topper']; ?></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonTopperOnly['CFv Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffTopperOnly['CFv Topper']; ?></td>
    <td>&nbsp;</td>
     <td bgcolor="#FFFFFF"><?= $OBLondonTopperOnly['CFv Topper']; ?></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffTopperOnly['CFv Topper']; ?></td>
 </tr>
 <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr> 
  <tr>
  <td><strong>Legs</strong></td>
      <td bgcolor="#FFFFFF"><?= $ProdLondonLegs; ?> 
      <form action="/php/itemsproduced/exportlegs" method="post" name="form2">
    <input id="type" name="type" type="hidden" value="prod">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form></td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffLegs; ?> 
    <form action="/php/itemsproduced/exportlegs" method="post" name="form2">
    <input id="type" name="type" type="hidden" value="prod">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
    </td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonLegs; ?> 
     <form action="/php/itemsproduced/exportlegs" method="post" name="form2">
    <input id="type" name="type" type="hidden" value="item">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form></td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffLegs; ?> 
     <form action="/php/itemsproduced/exportlegs" method="post" name="form2">
    <input id="type" name="type" type="hidden" value="item">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
    </td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonLegs; ?> 
    <form action="/php/itemsproduced/exportlegs" method="post" name="form2">
    <input id="type" name="type" type="hidden" value="OB">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form></td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffLegs; ?> 
    <form action="/php/itemsproduced/exportlegs" method="post" name="form2">
    <input id="type" name="type" type="hidden" value="OB">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td><strong>Headboards</strong></td>
    <td bgcolor="#FFFFFF"><?= $ProdLondonHB; ?> 
    <form action="/php/itemsproduced/exporthb" method="post" name="form2">
    <input id="type" name="type" type="hidden" value="prod">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
    </td>
    <td bgcolor="#FFFFFF"><?= $ProdCardiffHB; ?> 
    <form action="/php/itemsproduced/exporthb" method="post" name="form2">
    <input id="type" name="type" type="hidden" value="prod">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $ItemLondonHB; ?> 
    <form action="/php/itemsproduced/exporthb" method="post" name="form2">
    <input id="type" name="type" type="hidden" value="item">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
   </td>
    <td bgcolor="#FFFFFF"><?= $ItemCardiffHB; ?> 
    <form action="/php/itemsproduced/exporthb" method="post" name="form2">
    <input id="type" name="type" type="hidden" value="item">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
    </td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><?= $OBLondonHB; ?> 
    <form action="/php/itemsproduced/exporthb" method="post" name="form2">
    <input id="type" name="type" type="hidden" value="OB">
    <input id="madeat" name="madeat" type="hidden" value="2">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
    </td>
    <td bgcolor="#FFFFFF"><?= $OBCardiffHB; ?> 
    <form action="/php/itemsproduced/exporthb" method="post" name="form2">
    <input id="type" name="type" type="hidden" value="OB">
    <input id="madeat" name="madeat" type="hidden" value="1">
    <input id="dateto" name="dateto" type="hidden" value="<?=$dateto ?>">
    <input id="datefrom" name="datefrom" type="hidden" value="<?=$datefrom ?>">
    <input type="submit" value="CSV">
    </form>
   </td>
  </tr>  
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
</table>
<?php  } ?>      
  </div>  

</div>