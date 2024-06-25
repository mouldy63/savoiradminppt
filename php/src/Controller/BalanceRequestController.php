<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class BalanceRequestController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		set_time_limit(120);
		$this->loadModel('Communication');
		$this->loadModel('Correspondence');
		$this->loadModel('Purchase');
		$this->loadModel('Location');
		$this->loadModel('SavoirUser');
		$this->loadModel('ProductionSizes');
		$this->loadModel('Accessory');
    }
	
    public function index() {
		$this->viewBuilder()->setLayout('printx');
		$this->viewBuilder()->setOptions([
            'pdfConfig' => [
                'orientation' => 'portrait',
            ]
        ]);
		$docroot=$_SERVER['DOCUMENT_ROOT'];
        $this->set('docroot', $docroot);
        
        $proto = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') ? 'https' : 'http';
    	
    	//debug($this->request->getData());
		$contactTable = TableRegistry::get('Contact');
		$addressTable = TableRegistry::get('Address');
		$purchaseTable = TableRegistry::get('Purchase');
		$showroomTable = TableRegistry::get('Location');
		$userTable = TableRegistry::get('SavoirUser');
		$accTable = TableRegistry::get('Accessory');
		$params = $this->request->getParam('?');
        $pn = $params['pn'];
        
        $query = $this->Purchase->find()->where(['PURCHASE_No' => $pn]);
		foreach ($query as $row) {
			$purchase = $row;
			
		}
		
		
		
		$query = $this->Location->find()->where(['idlocation' => $purchase['idlocation']]);
		foreach ($query as $row) {
			$location = $row;
		}
	    $showroomtel=$location['tel'];
	    $locationname=$location['location'];
		$this->set('locationname', $locationname);
		$client=$contactTable->getContact($purchase['contact_no'])[0];
		
		$query = $this->SavoirUser->find()->where(['username' => $purchase['salesusername']]);
		foreach ($query as $row) {
			$salesuser = $row;
		}
		$username=$salesuser['name'];
		$this->set('username', $username);	
        
        $header = "<p align=center><img src='webroot/img/logo-s.gif' width='255' height='40' style='position:relative; margin-top:0px;' /></p>";
		$header .= "<p align=center>Order No: ".$purchase['ORDER_NUMBER']."<br>FINAL BALANCE REQUEST</p><br><br><p>";
		$address='<p>';
		if ($client['title'] != '') {
		$address .= ucwords($client['title'])." ";
		}
		if ($client['first'] != '') {
		$address .= ucwords($client['first'])." ";
		}
		if ($client['surname'] != '') {
		$address .= ucwords($client['surname'])."<br>";
		}
		if ($client['company'] != '') {
		$address .= ucwords($client['company'])."<br>";
		}
		if ($client['street1'] != '') {
		$address .= ucwords($client['street1'])."<br>";
		}
		if ($client['street2'] != '') {
		$address .= ucwords($client['street2'])."<br>";
		}
		if ($client['street3'] != '') {
		$address .= ucwords($client['street3'])."<br>";
		}
		if ($client['town'] != '') {
		$address .= ucwords($client['town'])."<br>";
		}
		if ($client['county'] != '') {
		$address .= ucwords($client['county'])."<br>";
		}
		if ($client['postcode'] != '') {
		$address .= ucwords($client['postcode'])."<br>";
		}
		if ($client['country'] != '') {
		$address .= ucwords($client['country'])."<br>";
		}
		$address .= "</p><p>Dear ";
		if ($client['title'] != '') {
		$address .= ucwords($client['title'])." ";
		}
		if ($client['surname'] != '') {
		$address .= ucwords($client['surname'])." ";
		}
		$address .= "</p>";
		
		$bankref=$purchase['ORDER_NUMBER'];
		$bankref.="-".$client['surname'];
		$this->set('bankref', $bankref);
		$this->set('header', $header);
		$this->set('showroomtel', $showroomtel);
		$this->set('address', $address);
		
		if ($purchase['ordercurrency']=='GBP') {
			$currencysymbol='&pound;';
		}
		if ($purchase['ordercurrency']=='USD') {
			$currencysymbol='&#36;';
		}
		if ($purchase['ordercurrency']=='EUR') {
			$currencysymbol='&#8364;';
		}
		$mattressinc='n';
		$baseinc='n';
		$topperinc='n';
		$valanceinc='n';
		$legsinc='n';
		$hbinc='n';
		$accinc='n';
		if ($purchase['mattressrequired']=='y') {
			$mattressinc='y';
		}
		if ($purchase['baserequired']=='y') {
			$baseinc='y';
		}
		if ($purchase['topperrequired']=='y') {
			$topperinc='y';
		}
		if ($purchase['valancerequired']=='y') {
			$valanceinc='y';
		}
		if ($purchase['legsrequired']=='y') {
			$legsinc='y';
		}
		if ($purchase['headboardrequired']=='y') {
			$hbinc='y';
		}
		if ($purchase['accessoriesrequired']=='y') {
			$accinc='y';
		}

		
		$query = $this->ProductionSizes->find()->where(['Purchase_No' => $pn]);
		$psizes = null;
		foreach ($query as $row) {
			$psizes = $row;
		}
						
		$prodtable="<table width='100%' border='0' cellspacing='0' cellpadding='3'>";
		$prodtable .="<tr><td width='40%'><b>Bed Model</b></td><td><b>Size</b></td><td align='center'><b>Qty</b></td><td align='right'><b>Unit Price/".$purchase['ordercurrency']."</b></td><td align='right'><b>Price/".$purchase['ordercurrency']."</b></td></tr>";
		if ($mattressinc=='y') {
		if (substr($purchase['mattresswidth'], 0, 3) != 'Spe') {
			$mattsize=$purchase['mattresswidth']." x ";
		} else {
			$mattsize=$psizes['Matt1Width']." x ";
		}
		if (substr($purchase['mattresslength'], 0, 3) != 'Spe') {
			$mattsize.=$purchase['mattresslength'];
		} else {
			$mattsize.=$psizes['Matt1Length']."cm";
		}
		if (!empty($psizes['Matt2Width'])) {
			$mattsize.="<br>" .$psizes['Matt2Width']." x ";
		}
		if (!empty($psizes['Matt2Length'])) {
			$mattsize.=$psizes['Matt2Length']."cm";
		}
		$mattressdesc=$purchase['savoirmodel']." Mattress";
		if ($purchase['tickingoptions'] != 'n') {
			$mattressdesc.=", ".$purchase['tickingoptions'];
		}
		if ($purchase['mattresstype'] != 'n' && !empty($purchase['mattresstype'])) {
			$mattressdesc.=", ".$purchase['mattresstype'];
		}
		$mattressdesc.="<br />Left Support: ".$purchase['leftsupport'].".  Right Support: ".$purchase['leftsupport'];
		$prodtable .="<tr><td width='40%'>".$mattressdesc."</td><td>".$mattsize."</td><td align='center'>1</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['mattressprice'], $purchase['ordercurrency']) ."</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['mattressprice'], $purchase['ordercurrency']) ."</td></tr>";
		}
		
		if ($baseinc=='y') {
		if (substr($purchase['basewidth'], 0, 3) != 'Spe') {
			$basesize=$purchase['basewidth']." x ";
		} else {
			$basesize=$psizes['Base1Width']." x ";
		}
		if (substr($purchase['baselength'], 0, 3) != 'Spe') {
			$basesize.=$purchase['baselength'];
		} else {
			$basesize.=$psizes['Base1Length']."cm";
		}
		if (!empty($psizes['Base2Width'])) {
			$basesize.="<br>" .$psizes['Base2Width']." x ";
		}
		if (!empty($psizes['Base2Length'])) {
			$basesize.=$psizes['Base2Length']."cm";
		}
		$basedesc=$purchase['basesavoirmodel']." Base";
		if ($purchase['basetickingoptions'] != 'n') {
			$basedesc.=", ".$purchase['basetickingoptions'];
		}
		if ($purchase['basetype'] != 'n' && !empty($purchase['basetype'])) {
			$basedesc.=", ".$purchase['basetype'];
		}
		
		$prodtable .="<tr><td width='40%'>".$basedesc."</td><td>".$basesize."</td><td align='center'>1</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['baseprice'], $purchase['ordercurrency']) ."</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['baseprice'], $purchase['ordercurrency']) ."</td></tr>";
		
		if (!empty($purchase['basefabricprice']) && $purchase['basefabricprice'] != 0) {
		$prodtable .="<tr><td width='40%'>Base fabric ".$purchase['basefabric']."<br>".$purchase['basefabricchoice']."</td><td>Meters</td><td align='center'>".$purchase['basefabricmeters']."</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['basefabriccost'], $purchase['ordercurrency']) ."</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['basefabricprice'], $purchase['ordercurrency']) ."</td></tr>";
		}
		
		if (!empty($purchase['upholsteryprice']) && $purchase['upholsteryprice'] != 0) {
		$prodtable .="<tr><td width='40%'>Upholstered Base</td><td>&nbsp;</td><td align='center'>1</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['upholsteryprice'], $purchase['ordercurrency']) ."</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['upholsteryprice'], $purchase['ordercurrency']) ."</td></tr>";
		}
		
		}		
		
		if ($topperinc=='y') {
		if (substr($purchase['topperwidth'], 0, 3) != 'Spe') {
			$toppersize=$purchase['topperwidth']." x ";
		} else {
			$toppersize=$psizes['topper1Width']." x ";
		}
		if (substr($purchase['topperlength'], 0, 3) != 'Spe') {
			$toppersize.=$purchase['topperlength'];
		} else {
			$toppersize.=$psizes['topper1Length']."cm";
		}
		$topperdesc=$purchase['toppertype'];
		if (!empty($purchase['toppertickingoptions'] && $purchase['toppertickingoptions'] != 'n')) {
			$topperdesc .= "<br>".$purchase['toppertickingoptions'];
		}
		if ($purchase['topperprice'] != '' && !empty($purchase['topperprice'])) {
			$topperprice=$purchase['topperprice'];
		} else {
			$topperprice=0;
		}
				
		$prodtable .="<tr><td width='40%'>".$topperdesc."</td><td>".$toppersize."</td><td align='center'>1</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($topperprice, $purchase['ordercurrency']) ."</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($topperprice, $purchase['ordercurrency']) ."</td></tr>";	
	}
	
	if ($valanceinc=='y') {
		if ($purchase['valfabriccost'] != '' && !empty($purchase['valfabriccost'])) {
			$valfabriccost=$purchase['valfabriccost'];
			} else {
			$valfabriccost=0;
		}
		if ($purchase['valfabricprice'] != '' && !empty($purchase['valfabricprice'])) {
			$valfabricprice=$purchase['valfabricprice'];
			} else {
			$valfabricprice=0;
		}
		if ($purchase['valanceprice'] != '' && !empty($purchase['valanceprice'])) {
			$valanceprice=$purchase['valanceprice'];
			} else {
			$valanceprice=0;
		}
		$valancesize='';
		if ($purchase['valancedrop'] != '') {
			$valancesize.=$purchase['valancedrop']. " x ";
		}
		if ($purchase['valancewidth'] != '') {
			$valancesize.=$purchase['valancewidth']. " x ";
		}
		if ($purchase['valancelength'] != '') {
			$valancesize.=$purchase['valancelength']. "cm";
		}
		$valancedesc="Valance";
		if ($purchase['valancefabricchoice'] != '') {
			$valancedesc.="<br>".$purchase['valancefabricchoice'];
		}
		
		
		$prodtable .="<tr><td width='40%'>".$valancedesc."</td><td>".$valancesize."<br>Meters</td><td align='center'>1<br>".$purchase['valancefabricmeters']."</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['valanceprice'], $purchase['ordercurrency']) ."<br>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['valfabriccost'], $purchase['ordercurrency']) ."</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['valanceprice'], $purchase['ordercurrency']) ."<br>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['valfabriccost'], $purchase['ordercurrency']) ."</td></tr>";	
	}
	
	
	if ($legsinc=='y') {
		$legprice=0;
		$legqty=0;
		$individuallegprice=0;
		if ($purchase['legprice'] != '' && !empty($purchase['legprice'])) {
			$legprice=$purchase['legprice'];
		} 
		
		if ($purchase['LegQty'] != '' && !empty($purchase['LegQty'])) {
			$legqty=$purchase['LegQty'];
			
		}
		if ($purchase['AddLegQty'] != '' && !empty($purchase['AddLegQty'])) {
			$legqty=intval($legqty) + intval($purchase['AddLegQty']);
		}
		if ($legqty==0 && $legprice>0) {
			$individuallegprice=$legprice;
		}
		if ($legqty>0 && $legprice>0) {
			$individuallegprice=$legprice/$legqty;
		}
		$legspecial='';
		if ($purchase['$legstyle']=="Special Instructions" || $purchase['$legstyle']=="Special (as instructions)") {
			$legspecial=$purchase['specialinstructionslegs'];
		}
		$legdesc=$purchase['legstyle']. " Legs<br>".$purchase['legfinish']." ".$legspecial;		
		
		$prodtable .="<tr><td width='40%'>".$legdesc."</td><td>".$purchase['legheight']."</td><td align='center'>".$legqty."</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($individuallegprice, $purchase['ordercurrency']) ."</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($legprice, $purchase['ordercurrency']) ."</td></tr>";	
	}
	
	if ($hbinc=='y') {
		$hbwidth=0;
		if ($purchase['headboardWidth'] != 'n' && !empty($purchase['headboardWidth'])) {
			$hbwidth=$purchase['headboardWidth'];
		} else {
			if ($purchase['baserequired']=='y' && $purchase['basewidth'] !='n' && !empty($purchase['basewidth']) && substr($purchase['basewidth'], 0, 4) != 'Spec') {
				$lenstr=strlen($purchase['basewidth'])-2;
				$hbwidth=substr($purchase['basewidth'], 0, $lenstr);
			}
			if ($purchase['mattressrequired']=='y' && $purchase['mattresswidth'] !='n' && !empty($purchase['mattresswidth']) && substr($purchase['mattresswidth'], 0, 4) != 'Spec') {
				$lenstr=strlen($purchase['mattresswidth'])-2;
				$hbwidth=substr($purchase['mattresswidth'], 0, $lenstr);
			}
			if ($purchase['baserequired']=='y' && substr($purchase['basewidth'], 0, 4) == 'Spec') {
				$hbwidth=$psizes['Base1Width'];
				if (!empty($psizes['Base2Width'])) {
				$hbwidth=$psizes['Base1Width']+$psizes['Base2Width'];
				}
			}
			if ($purchase['mattressrequired']=='y' && substr($purchase['mattresswidth'], 0, 4) == 'Spec') {
				$hbwidth=$psizes['Matt1Width'];
				if (!empty($psizes['Matt2Width'])) {
				$hbwidth=$psizes['Matt1Width']+$psizes['Matt2Width'];
				}
			}
			$hbwidth .= 'cm wide<br />';
		}
		$hbdesc=$purchase['headboardstyle']." Headboard";
		if (!empty($purchase['specialinstructionsheadboard'])) {
			$hbdesc .= "<br>".$purchase['specialinstructionsheadboard'];
		}
		$prodtable .="<tr><td width='40%'>".$hbdesc."</td><td>".$hbwidth."</td><td align='center'>1</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['headboardprice'], $purchase['ordercurrency']) ."</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['headboardprice'], $purchase['ordercurrency']) ."</td></tr>";
		
		if (!empty($purchase['hbfabricprice']) && $purchase['hbfabricprice'] != 0) {
		
			$prodtable .="<tr><td>Headboard Fabric ".($purchase['headboardfabric'])."<br />" .($purchase['headboardfabricchoice']);
			$prodtable .="</td><td>Meters</td><td align='center'>". ($purchase['hbfabricmeters'])."</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['hbfabriccost'], $purchase['ordercurrency'])."</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['hbfabricprice'], $purchase['ordercurrency'])."</td></tr>";
		
		}
	}
		
		
	if ($accinc=='y') {
		
		$query = $this->Accessory->find()->where(['purchase_no' => $pn]);
		foreach ($query as $row) {
			$acc = $row;
			$accprice=0;
			$accprice=$acc['unitprice'] * $acc['qty'];
			$prodtable .="<tr><td width='40%'>".$acc['description']. " ". $acc['colour']. " ". $acc['design']."</td><td>".$acc['size']."</td><td align='center'>".$acc['qty']."</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['unitprice'], $purchase['ordercurrency']) ."</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($accprice, $purchase['ordercurrency']) ."</td></tr>";	
			
		}
	}	
		
	
			
	if ($purchase['deliverycharge']=='y') {
		$prodtable .="<tr><td>Delivery Charge</td><td>&nbsp;</td><td align='center'>1</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['deliveryprice'], $purchase['ordercurrency'])."</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['deliveryprice'], $purchase['ordercurrency'])."</td></tr>";
	
	}
	
	
	$prodtable .="<tr><td width='80%' colspan='4'>Sub Total:</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['subtotal'], $purchase['ordercurrency'])."</td></tr><tr><td colspan='4'>VAT: ".floatval($purchase['vatrate'])."%</td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['vat'], $purchase['ordercurrency'])."</td></tr><tr><td colspan='4'>Gross Total: </td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['total'], $purchase['ordercurrency'])."</td></tr><tr><td colspan='4'>Deposit Paid: </td><td align='right'>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['paymentstotal'], $purchase['ordercurrency'])."</td></tr><tr><td colspan='4'><b>Balance Outstanding:</b> </td><td align='right'><b>".UtilityComponent::formatMoneyWithHtmlSymbol($purchase['balanceoutstanding'], $purchase['ordercurrency'])."</b></td></tr>";
	
	
	
	$prodtable .="</table>";
	
	$this->set('prodtable', $prodtable);
	}
	
	protected function _getAllowedRoles() {
		return ["ADMINISTRATOR","SALES"];
	}
    
}

?>