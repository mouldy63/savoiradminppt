<?php

namespace App\Controller\Component;

use Cake\ORM\TableRegistry;
use \DateTime;
use Cake\Datasource\ConnectionManager;
use \App\Controller\EmailServicesController;
use \App\Controller\Component\UtilityComponent;

class OrderEmailHelperComponent extends \Cake\Controller\Component {
	
	public function initialize($config): void {
        parent::initialize($config);
        TableRegistry::getTableLocator()->remove('Purchase');
        $this->Purchase = TableRegistry::getTableLocator()->get('Purchase');
        $this->Accessory = TableRegistry::getTableLocator()->get('Accessory');
        $this->Contact = TableRegistry::getTableLocator()->get('Contact');
        $this->Address = TableRegistry::getTableLocator()->get('Address');
        $this->Location = TableRegistry::getTableLocator()->get('Location');
        $this->SavoirUser = TableRegistry::getTableLocator()->get('SavoirUser');
        $this->OrderType = TableRegistry::getTableLocator()->get('OrderType');
        $this->OrderNote = TableRegistry::getTableLocator()->get('OrderNote');
        $this->PhoneNumber = TableRegistry::getTableLocator()->get('PhoneNumber');
        $this->ProductionSizes = TableRegistry::getTableLocator()->get('ProductionSizes');
    }

    public function sendNewOrderToSales($pn, $salesusername, $userregion, $idlocation) {
        $purchase = $this->Purchase->get($pn);
        $contact = $this->Contact->get($purchase['contact_no']);
        $showroom = $this->Location->get($idlocation);
        if ($salesusername=='maddy') {
            $to='info@natalex.co.uk';
        } else if ($salesusername=='dave') {
            $to='david@natalex.co.uk';
        } else if ($userregion==17 || $userregion==19) {
            $to='SavoirAdminNewOrder@savoirbeds.co.uk';
        } else {
            $to=$this->SavoirUser->find()->where(['username' => $salesusername])->first()['adminemail'];
        }
        $cc = null;
        $from = "noreply@savoirbeds.co.uk";
        $fromName = null;
        $subject='New Order '.$purchase['ORDER_NUMBER'].', '.$salesusername.' - '.$showroom['adminheading'];
        $body = '<html><body><font face="Arial, Helvetica, sans-serif">The following order has been placed on Savoir Admin, this needs to be confirmed before it proceeds to production.  Please log in to Savoir Admin and check the <b>Orders to be Confirmed</b> list<br /><br />';
        $body .= $contact['title'].' ' .$contact['surname'].' ';
        if ($purchase['companyname'] != '') {
            $body .= $purchase['companyname'].' ';
        }
        $body .= '- Order number '.$purchase['ORDER_NUMBER'].'. <br>Order date: ' .$purchase['ORDER_DATE'].'<br />';
        $body .= 'Order Value: '.$purchase['total'];
        $body .= '</font></body></html>';
        $emailServices = new EmailServicesController();
        $emailServices->generateBatchEmail($to, $cc, $from, $fromName, $subject, $body, 'html', '');
	}

    public function sendDepositEmailToAccounts($pn, $paymentmethod, $deposit, $pricelist, $receiptno, $idlocation) {
        $purchase = $this->Purchase->get($pn);
        $contact = $this->Contact->get($purchase['contact_no']);
        
        $showroom = $this->Location->get($idlocation);
        $to = "SavoirAdminAccounts@savoirbeds.co.uk";
        $cc = null;
        $from = "noreply@savoirbeds.co.uk";
        $fromName = null;
        $subject=$contact['surname'];
        if ($purchase['companyname'] != '') {
            $subject.= ' - '.$purchase['companyname'];
        }
        $subject.=' - '.$purchase['ORDER_NUMBER'].' - '.$purchase['ordercurrency'].' '.$deposit.' - '.$paymentmethod;
        $body = '<html><body><font face="Arial, Helvetica, sans-serif"><b>CUSTOMER PAYMENT</b><br /><table width="98%" border="1"  cellpadding="3" cellspacing="0">';
        $body .= '<tr><td>Order Type</td><td>'.$this->OrderType->get($purchase['ordertype'])['ordertype'].'</td></tr>';
        $body .= '<tr><td>Payment Amount</td><td>'.UtilityComponent::formatMoneyWithHtmlSymbol($deposit, $purchase['ordercurrency']).'</td></tr>';
        $body .= '<tr><td>Payment Type</td><td>'.$paymentmethod.'</td></tr>';
        $body .= '<tr><td>Customer Surname</td><td>'.$contact['surname'].'</td></tr>';
        $body .= '<tr><td>Company</td><td>'.$purchase['companyname'].'</td></tr>';
        $body .= '<tr><td>Order No</td><td>'.$purchase['ORDER_NUMBER'].'</td></tr>';
        $body .= '<tr><td>Amount Outstanding on this order</td><td>'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['total']-$deposit, $purchase['ordercurrency']).'</td></tr>';
        $body .= '<tr><td>Order Total Amount</td><td>'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['total'], $purchase['ordercurrency']).'</td></tr>';
        $body .= '<tr><td>Payment Source</td><td>'.$showroom['adminheading'].'</td></tr>';
        $body .= '<tr><td>Price List</td><td>'.$pricelist.'</td></tr>';
        $body .= '<tr><td>Receipt No</td><td>'.$receiptno.'</td></tr>';
        $body .= '</font></body></html>';
        $emailServices = new EmailServicesController();
        $emailServices->generateBatchEmail($to, $cc, $from, $fromName, $subject, $body, 'html', '');
}

public function sendOrderToBedworks($pn, $salesusername, $userregion, $idlocation) {
    $purchase = $this->Purchase->get($pn);
    $contact = $this->Contact->get($purchase['contact_no']);
    $address = $this->Address->get($contact['CODE']);
    $showroom = $this->Location->get($idlocation);
    $ordernotes=$this->OrderNote->getOrderNotes($pn);
    $prodsizes = $this->ProductionSizes->find()->where(['Purchase_No' => $pn])->first();
    $phonenumbers = $this->PhoneNumber->getNumbersForPurchase($pn);
    $accessories=$this->Accessory->getAccessories($pn);
    $phone1='';
    $phone2='';
    $phone3='';
    foreach ($phonenumbers as $phonenumber) {
        if ($phonenumber['seq']==1) {
            $phone1=$phonenumber['phonenumbertype'].': '.$phonenumber['number'];
        }
        if ($phonenumber['seq']==2) {
            $phone2=$phonenumber['phonenumbertype'].': '.$phonenumber['number'];
        }
        if ($phonenumber['seq']==3) {
            $phone3=$phonenumber['phonenumbertype'].': '.$phonenumber['number'];
        }
    }
    if ($salesusername=='maddy') {
        $to='info@natalex.co.uk';
    } else if ($salesusername=='dave') {
        $to='david@natalex.co.uk';
    } else {
        $to='SavoirAdminNewOrder@savoirbeds.co.uk';
    } 
    $cc = null;
    $from = "noreply@savoirbeds.co.uk";
    $fromName = null;   
    $subject='New Order - '.$contact['surname'].' - '.$purchase['ORDER_NUMBER'].' - '.$showroom['adminheading'];
    $body = '<html><body><font face="Arial, Helvetica, sans-serif">This auto generated email has been sent to the distribution group called SavoirAdminNewOrder@savoirbeds.co.uk and confirms the following new order<br /><br />';
    $body .= '<b>CUSTOMER DETAILS</b><br /><table width="98%" border="1"  cellpadding="3" cellspacing="0">';
    $body .= '<tr><td width="10%">Contact:</td><td width="23%">'.$purchase['salesusername'].'</td>';
    $body .= '<td colspan="2">Invoice Address:</td><td colspan="2">Delivery Address:</td></tr>';
    $body .= '<tr><td>Order No:</td><td>'.$purchase['ORDER_NUMBER'].'</td>';
    $body .= '<td width="8%">Line 1: </td><td width="28%">'.$address['street1'].'</td>';
    $body .= '<td width="8%">Line 1: </td><td width="23%">'.$purchase['deliveryadd1'].'</td></tr>';
    $body .= '<tr><td>Date of order: </td><td>'.$purchase['ORDER_DATE'].'</td>';
    $body .= '<td>Line 2: </td><td>'.$address['street2'].'</td>';
    $body .= '<td>Line 2: </td><td>'.$purchase['deliveryadd2'].'</td></tr>';
    $body .= '<tr><td>Customer Reference:</td><td>'.$purchase['customerreference'].'</td>';
    $body .= '<td>Line 3:</td><td>'.$address['street3'].'</td>';
    $body .= '<td>Line 3:</td><td>'.$purchase['deliveryadd3'].'</td></tr>';
    $body .= '<tr><td>Clients Title:</td><td>'.$contact['title'].'</td>';
    $body .= '<td>Town: </td><td>'.$address['town'].'</td>';
    $body .= '<td>Town: </td><td>'.$purchase['deliverytown'].'</td></tr>';
    $body .= '<tr><td>First Name:</td><td>'.$contact['first'].'</td>';
    $body .= '<td>County: </td><td>'.$address['county'].'</td>';
    $body .= '<td>County: </td><td>'.$purchase['deliverycounty'].'</td></tr>';
    $body .= '<tr><td>Surname:</td><td>'.$contact['surname'].'</td>';
    $body .= '<td>Postcode: </td><td>'.$address['postcode'].'</td>';
    $body .= '<td>Postcode: </td><td>'.$purchase['deliverypostcode'].'</td></tr>';
    $body .= '<tr><td>Tel Home:</td><td>'.$address['tel'].'</td>';
    $body .= '<td>Country: </td><td>'.$address['country'].'</td>';
    $body .= '<td>Country: </td><td>'.$purchase['deliverycountry'].'</td></tr>';
    $body .= '<tr><td>Tel Work: </td><td>'.$contact['telwork'].'</td><td>Company Name: </td><td>'.$address['company'].'</td><td>Contact number 1:</td><td>'.$phone1.'</td></tr>';
    $body .= ' <tr><td>Mobile: </td><td>'.$contact['mobile'].'</td><td></td><td></td><td>Contact number 2:</td><td>'.$phone2.'</td></tr>';
    $body .= ' <tr><td></td><td></td><td></td><td></td><td>Contact number 3:</td><td>'.$phone3.'</td></tr>';
    $body .= ' <tr><td>Email: </td><td>'.$address['EMAIL_ADDRESS'].'</td><td></td><td></td><td></td><td></td></tr>';
    $body .= ' <tr><td>Order Type: </td><td>'.$this->OrderType->get($purchase['ordertype'])['ordertype'].'</td><td>Approx. Delivery Date:</td><td>'.$purchase['deliverydate'].'</td><td>Booked Delivery Date: </td><td>'.$purchase['bookeddeliverydate'].'</td></tr>';
    $body .= ' </table>';
    
    if (isset($ordernotes)) {
        $body .= '<br/><b>ORDER NOTES</b><table width="98%" border="1" align="center" cellpadding="3" cellspacing="0">';
        $body .= '<tr><td>Note Text</td><td>Follow-up date</td><td>Action</td></tr>';
        foreach ($ordernotes as $note) {
            $body .= '<tr><td>'.$note['notetext'].'</td><td>'.$note['followupdate'].'&nbsp;</td><td>'.$note['action'].'</td></tr>';
        }
        $body .= '</table>';

    }
    $body .= '<br /><b>MATTRESS</b>';
    if ($purchase['mattressrequired']=='y') {
        $body .= '<table width="98%" border="1" cellpadding="3" cellspacing="0">';
        $body .= '<tr><td width="11%">Savoir Model:</td><td width="22%">'.$purchase['savoirmodel'].'</td>';
        $body .= '<td width="10%">Mattress Type: </td><td>'.$purchase['mattresstype'].'</td>';
        $body .= '<td width="8%">Ticking Options</td><td width="24%">'.$purchase['tickingoptions'].'</td></tr>';
        $body .= '<tr><td>Mattress Width:</td><td>'.$purchase['mattresswidth'];
        if (isset($prodsizes)) {
            if ($prodsizes['Matt1Width']!='') {
                $body .= ' Mattress 1 Width: '.$prodsizes['Matt1Width'];
            }
            if ($prodsizes['Matt1Width']!='') {
                $body .= ' Mattress 2 Width: '.$prodsizes['Matt2Width'];
            }
        }
        $body .= '</td><td width="10%">Mattress Length:</td><td width="25%">'.$purchase['mattresslength'];
        if (isset($prodsizes)) {
            if ($prodsizes['Matt1Length']!='') {
                $body .= ' Mattress 1 Length: '.$prodsizes['Matt1Length'];
            }
            if ($prodsizes['Matt2Length']!='') {
                $body .= ' Mattress 2 Length: '.$prodsizes['Matt2Length'];
            }
        }
        $body .= '</td><td colspan="2">';
        if ($purchase['tickingoptions']=='White Trellis') {
            $body .= '<img src="http://www.savoiradmin.co.uk/img/white-trellis.jpg" align="right">';
        }
        if ($purchase['tickingoptions']=='Grey Trellis') {
            $body .= '<img src="http://www.savoiradmin.co.uk/img/grey-trellis.jpg" align="right">';
        }
        if ($purchase['tickingoptions']=='Silver Trellis') {
            $body .= '<img src="http://www.savoiradmin.co.uk/img/silver-trellis.jpg" align="right">';
        }
        if ($purchase['tickingoptions']=='Oatmeal Trellis') {
            $body .= '<img src="http://www.savoiradmin.co.uk/img/oatmeal-trellis.jpg" align="right">';
        }
        $body .= '&nbsp;</td></tr></table>';
        $body .= '<p><b>Support (as viewed from the foot looking toward the head end):</b></p>';
        $body .= '<table width="98%" border="1" cellpadding="3" cellspacing="0">';
        $body .= '<tr><td width="11%">Left Support:</td><td width="14%">'.$purchase['leftsupport'].'</td>';
        $body .= '<td width="11%">Right Support: </td><td width="13%">'.$purchase['rightsupport'].'</td>';
        $body .= '<td width="11%">Vent Position:</td><td width="16%">'.$purchase['ventposition'].'</td>';
        $body .= '<td width="10%">Vent Finish:</td><td width="14%">'.$purchase['ventfinish'].'</td></tr></table>';
        $body .= '<p class="greybox"><b>Special Instructions:</b></p><p>'.$purchase['mattressinstructions'].'</p>';
        if ($purchase['mattressprice'] != '') {
            $body .= '<p><b>Mattress Price </b>'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['mattressprice'], $purchase['ordercurrency']).'</p>';
        }
    } else {
        $body .= '<p>No mattress required</p>';
    }

    $body .= '<br /><b>TOPPER</b>';
    if ($purchase['topperrequired']=='y') {
        $body .= '<table width="98%" border="1" cellpadding="3" cellspacing="0">';
        $body .= '<tr><td width="11%">Topper Type:</td><td width="22%">'.$purchase['toppertype'].'</td>';
        $body .= '<td>Topper Width: </td><td>'.$purchase['topperwidth'];
        if (isset($prodsizes)) {
            if ($prodsizes['topper1Width']!='') {
                $body .= ' Topper Width: '.$prodsizes['topper1Width'];
            }
        }
        $body .= '</td>';
        $body .= '<td>Topper Length: </td><td>'.$purchase['topperlength'];
        if (isset($prodsizes)) {
            if ($prodsizes['topper1Length']!='') {
                $body .= ' Topper Length: '.$prodsizes['topper1Length'];
            }
        }
        $body .= '</td></tr>';
        $body .= '<tr><td>Ticking Options:</td><td>'.$purchase['toppertickingoptions'].'</td>';
        $body .= '<td width="10%">&nbsp;</td><td width="25%">&nbsp;</td><td>&nbsp;</td><td>';
        if ($purchase['toppertickingoptions']=='White Trellis') {
            $body .= '<img src="http://www.savoiradmin.co.uk/img/white-trellis.jpg" align="right">';
        }
        if ($purchase['toppertickingoptions']=='Grey Trellis') {
            $body .= '<img src="http://www.savoiradmin.co.uk/img/grey-trellis.jpg" align="right">';
        }
        if ($purchase['toppertickingoptions']=='Silver Trellis') {
            $body .= '<img src="http://www.savoiradmin.co.uk/img/silver-trellis.jpg" align="right">';
        }
        if ($purchase['toppertickingoptions']=='Oatmeal Trellis') {
            $body .= '<img src="http://www.savoiradmin.co.uk/img/oatmeal-trellis.jpg" align="right">';
        }
        $body .= '&nbsp;</td></tr></table>';
        $body .= '<p class="greybox"><b>Special Instructions:</b></p><p>'.$purchase['specialinstructionstopper'].'</p>';
        if ($purchase['topperprice'] != '') {
        $body .= '<p><b>Topper Price </b>'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['topperprice'], $purchase['ordercurrency']).'</p>';
        }
    } else {
        $body .= '<p>No topper required</p>';
    }

    $body .= '<br /><b>BASE</b>';
    if ($purchase['baserequired']=='y') {
        $body .= '<table width="98%" border="1" cellpadding="3" cellspacing="0">';
        $body .= '<tr><td>Savoir Model:</td><td>'.$purchase['basesavoirmodel'].'</td>';
        $body .= '<td>Base Type:</td><td>'.$purchase['basetype'].'</td>';
        $body .= '<td>Base Width: </td><td>'.$purchase['basewidth'];
        if (isset($prodsizes)) {
            if ($prodsizes['Base1Width']!='') {
                $body .= ' Base 1 Width: '.$prodsizes['Base1Width'];
            }
            if ($prodsizes['Base2Width']!='') {
                $body .= ' Base 2 Width: '.$prodsizes['Base2Width'];
            }
        }
        $body .= '</td></tr>';
        $body .= '<tr><td>Base Length:</td><td>'.$purchase['baselength'];
        if (isset($prodsizes)) {
            if ($prodsizes['Base1Length']!='') {
                $body .= ' Base 1 Length: '.$prodsizes['Base1Length'];
            }
            if ($prodsizes['Base2Length']!='') {
                $body .= ' Base 2 Length: '.$prodsizes['Base2Length'];
            }
        }
        $body .= '</td><td>Link Position:</td><td>'.$purchase['linkposition'].'</td>';
        $body .= '<td>Link Finish</td><td>'.$purchase['linkfinish'].'</td></tr>';
        if ($purchase['basedrawers']=='Yes') {
            $body .= '<tr><td>Drawers: </td><td>'.$purchase['basedrawers'].'</td><td>Drawer Config: </td>';
            $body .= '<td>Drawer Config: </td><td>'.$purchase['basedrawerconfigID'].'</td>';
            $body .= '<td>Drawer Height:  </td><td>'.$purchase['basedrawerheight'].'</td></tr>';
        }
        $body .= '</table>';
        $body .= '<p class="greybox"><b>Special Instructions:</b></p><p>'.$purchase['baseinstructions'].'</p>';
        $body .= '<p><b>Base Price </b>'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['baseprice'], $purchase['ordercurrency']).'</p>';

        $body .= '<p class="greybox"><b>Upholstery Fabric Options</b></p>';
        $body .= '<table width="98%" border="1" cellpadding="3" cellspacing="0">';
        $body .= '<tr><td width="11%">Upholstered Base:</td>';
        $body .= '<td width="12%">'.$purchase['upholsteredbase'].'</td>';
        $body .= '<td width="11%">Fabric Options: </td><td width="21%">'.$purchase['basefabric'].'</td>';
        $body .= '<td width="12%">Fabric Selection:</td><td width="33%">'.$purchase['basefabricchoice'].'</td></tr>';
        $body .= '<tr><td width="11%">Base Fabric Direction:</td>';
        $body .= '<td colspan="5">'.$purchase['basefabricdirection'].'</td>';
        $body .= '</tr></table>';
        $body .= '<p class="greybox"><b>Base Fabric Description:</b></p><p>'.$purchase['basefabricdesc'].'</p>';
        $body .= '<p><b>Upholstery Price </b>'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['upholsteryprice'], $purchase['ordercurrency']).'</p><br />';
    } else {
        $body .= '<p>No base required</p>';
    }

    $body .= '<br /><b>LEGS</b>';
    if ($purchase['legsrequired']=='y') {
        $body .= '<table width="98%" border="1" cellpadding="3" cellspacing="0"><tr>';
        $body .= '<td>Leg Style:</td><td>'.$purchase['legstyle'].'</td>';
        $body .= '<td>Leg Finish: </td><td>'.$purchase['legfinish'].'</td>';
        $body .= '<td>Leg Qty:</td><td>'.$purchase['LegQty'].'</td></tr>';
        $body .= '<tr><td>Additional Legs:</td><td>'.$purchase['AddLegQty'].'</td>';
        $body .= '<td>Leg Height:</td><td>'.$purchase['legheight'].'</td>';
        $body .= '<td>Floor Type:</td><td>'.$purchase['floortype'].'</td></tr></table>';
        $body .= '<p class="greybox"><b>Special Leg Instructions:</b></p><p>'.$purchase['specialinstructionslegs'].'</p>';
    } else {
        $body .= '<p>No legs required</p>';
    }

    $body .= '<br /><b>HEADBOARD</b>';
    if ($purchase['headboardrequired']=='y') {
        $body .= '<table width="98%" border="1" cellpadding="3" cellspacing="0">';
        $body .= '<tr><td>Headboard Styles:</td><td>'.$purchase['headboardstyle'].'</td>';
        $body .= '<td width="11%">Fabric Options:</td><td width="21%">'.$purchase['headboardfabric'].' ('.$purchase['hbfabricoptions'].')</td>';
        $body .= '<td width="12%">Fabric Selection:</td><td width="33%">'.$purchase['headboardfabricchoice'].'</td></tr>';
        $body .= '<tr><td>Headboard Height:</td><td>'.$purchase['headboardheight'].'</td><td>Headboard Finish:</td><td>'.$purchase['headboardfinish'].'&nbsp;</td><td>&nbsp;</td><td>';
        if ($purchase['headboardheight']=='C5') {
            $body .= '<img src="http://www.savoiradmin.co.uk/img/c5.gif" align="right">';
        }
        if ($purchase['headboardheight']=='C4') {
            $body .= '<img src="http://www.savoiradmin.co.uk/img/c4.gif" align="right">';
        }
        if ($purchase['headboardheight']=='C2') {
            $body .= '<img src="http://www.savoiradmin.co.uk/img/c2.gif" align="right">';
        }
        if ($purchase['headboardheight']=='C1') {
            $body .= '<img src="http://www.savoiradmin.co.uk/img/c1.gif" align="right">';
        }
        if ($purchase['headboardheight']=='C6') {
            $body .= '<img src="http://www.savoiradmin.co.uk/img/c6.gif" align="right">';
        }
        if ($purchase['headboardheight']=='M31') {
            $body .= '<img src="http://www.savoiradmin.co.uk/img/m31.gif" align="right">';
        }
        if ($purchase['headboardheight']=='M32') {
            $body .= '<img src="http://www.savoiradmin.co.uk/img/m32.gif" align="right">';
        }
        if ($purchase['headboardheight']=='Holly') {
            $body .= '<img src="http://www.savoiradmin.co.uk/img/holly.gif" align="right">';
        }
        if ($purchase['headboardheight']=='F100') {
            $body .= '<img src="http://www.savoiradmin.co.uk/img/f100.gif" align="right">';
        }
        $body .= '&nbsp;</td></tr>';
        $body .= '<tr><td>Headboard Fabric Direction</td><td>'.$purchase['headboardfabricdirection'].'</td><td>Supporting Leg Qty:</td><td>'.$purchase['headboardlegqty'].'</td><td>&nbsp;</td><td>&nbsp;</td></tr></table>';
        $body .= '<p class="greybox"><b>Headboard Fabric Description:</b></p><p>'.$purchase['headboardfabricdesc'].'</p>';
        $body .= '<p class="greybox"><b>Special Instructions:</b></p><p>'.$purchase['specialinstructionsheadboard'].'</p>';
        $body .= '<p><b>Headboard Price </b>'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['headboardprice'], $purchase['ordercurrency']).'</p>';
    } else {
        $body .= '<p>No headboard required</p>';
    }

    $body .= '<br /><b>VALANCE</b>';
    if ($purchase['valancerequired']=='y') {
        $body .= '<table width="98%" border="1" cellpadding="3" cellspacing="0">';
        $body .= '<tr><td width="11%">No. of Pleats:</td><td width="12%">'.$purchase['pleats'].'</td>';
        $body .= '<td width="11%">Fabric Options: </td><td width="21%">'.$purchase['valancefabric'].'</td>';
        $body .= '<td width="12%">Fabric Selection:</td><td width="33%">'.$purchase['valancefabricchoice'].'</td></tr>';
        $body .= '<tr><td width="11%">Valance Fabric Direction:</td><td width="12%">'.$purchase['valancefabricdirection'].'</td>';
        $body .= '<td width="11%">Valance Drop: </td><td width="21%">'.$purchase['valancedrop'].'</td>';
        $body .= '<td width="12%">Valance Width: </td><td width="33%">'.$purchase['valancewidth'].'</td></tr>';
        $body .= '<tr><td width="12%">Valance Length: </td><td colspan="5">'.$purchase['valancelength'].'</td></tr></table>';
        $body .= '<p class="greybox"><b>Special Instructions:</b></p>';
        $body .= '<p>'.$purchase['specialinstructionsvalance'].'</p>';
        if ($purchase['valanceprice'] != '') {
            $body .= '<p>'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['valanceprice'], $purchase['ordercurrency']).'</p>';
        }
    } else {
        $body .= '<p>No valance required</p>';
    }

    $body .= '<br /><b>ACCESSORIES</b>';
    if ($purchase['accessoriesrequired']=='y') {
        $body .= '<b>ACCESSORIES</b><br /><table width="98%" border="1" cellpadding="3" cellspacing="0">';
        $body .= '<tr><td><b>Description</b></td><td><b>Design</b></td><td><b>Colour</b></td><td><b>Size</b></td><td><b>Unit Price</b></td><td><b>Qty</b></td></tr>';
        foreach ($accessories as $accrow) {
            $body .= '<tr><td>'.$accrow['description'].'</td><td>'.$accrow['design'].'</td><td>'.$accrow['colour'].'</td>';
            $body .= '<td>'.$accrow['size'].'</td><td>'.UtilityComponent::formatMoneyWithHtmlSymbol($accrow['unitprice'], $purchase['ordercurrency']).'</td><td>'.$accrow['qty'].'</td></tr>';
        }
        $body .= '</table>';
    } else {
        $body .= '<p>No accessories required</p>';
    }
    $body .= '<p><b>DELIVERY CHARGE</b></p>';
    $body .= '<p>Access Check Required: '.$purchase['accesscheck'].'</p>';
    if ($purchase['deliverycharge']=='y') {
        if ($purchase['specialinstructionsdelivery'] != '') {
            $body .= '<p><b>Special Instructions: </b></p><p>'.$purchase['specialinstructionsdelivery'].'</p>';
        }
        if ($purchase['deliveryprice'] != '') {
            $body .= '<p><b>Delivery Charge: </b>  '.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['deliveryprice'], $purchase['ordercurrency']).'</p>';
        }
    } else {
        $body .= '<p>No delivery charge</p>';
    }
    $body .= '<p>Dispose of Old Bed? '.$purchase['oldbed'].'</p>';

    $body .= '<br><table width="463" border="1" cellpadding="0" cellspacing="2">';
    $body .= '<tr><td colspan="2"><strong>Order Summary - Order No. '.$purchase['ORDER_NUMBER'].'</strong></td></tr>';
    $body .= '<tr><td width="246">Mattress</td><td width="203" align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['mattressprice'], $purchase['ordercurrency']).'</td></tr>';
    $body .= '<tr><td>Topper</td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['topperprice'], $purchase['ordercurrency']).'</td></tr>';
    $body .= '<tr><td>Leg Price</td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['legprice'], $purchase['ordercurrency']).'</td></tr>';
    $body .= '<tr><td>Base</td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['baseprice'], $purchase['ordercurrency']).'</td></tr>';
    $body .= '<tr><td>Upholstered Base</td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['upholsteryprice'], $purchase['ordercurrency']).'</td></tr>';
    $body .= '<tr><td>Base Fabric Price</td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['basefabricprice'], $purchase['ordercurrency']).'</td></tr>';
    $body .= '<tr><td>Headboard</td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['headboardprice'], $purchase['ordercurrency']).'</td></tr>';
    $body .= '<tr><td>Headboard Fabric Price</td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['hbfabricprice'], $purchase['ordercurrency']).'</td></tr>';
    $body .= '<tr><td>Valance</td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['valanceprice'], $purchase['ordercurrency']).'</td></tr>';
    $body .= '<tr><td>Valance Fabric Price</td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['valfabricprice'], $purchase['ordercurrency']).'</td></tr>';
    $body .= '<tr><td>Accessories Total Cost</td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['accessoriestotalcost'], $purchase['ordercurrency']).'</td></tr>';
    $body .= '<tr><td><strong>Bed Set Total</strong></td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['bedsettotal'], $purchase['ordercurrency']).'</td></tr>';
    if ($purchase['discount'] != '') {
        $body .= '<tr><td>DC &nbsp;&nbsp;'.$purchase['discounttype'].'</td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['discount'], $purchase['ordercurrency']).'</td></tr>';
    }
    $body .= '<tr><td><strong>Sub Total</strong></td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['subtotal'], $purchase['ordercurrency']).'</td></tr>';
    $body .= '<tr><td>Delivery Charge</td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['deliveryprice'], $purchase['ordercurrency']).'</td></tr>';
    if ($purchase['tradediscount'] != '') {
        $body .= '<tr><td>Trade Discount</td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['tradediscount'], $purchase['ordercurrency']).'</td></tr>';
    }
    if ($purchase['totalexvat'] != '') {
        $body .= '<tr><td>Total excluding VAT</td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['totalexvat'], $purchase['ordercurrency']).'</td></tr>';
        $body .= '<tr><td>VAT</td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['vat'], $purchase['ordercurrency']).'</td></tr>';
    }
    $body .= '<tr><td><strong>TOTAL</strong></td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['total'], $purchase['ordercurrency']).'</td></tr>';
    $body .= '<tr><td><strong>Payments Total</strong></td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['paymentstotal'], $purchase['ordercurrency']).'</td></tr>';
    $body .= '<tr><td><strong>Balance Outstanding</strong></td><td align="right">'.UtilityComponent::formatMoneyWithHtmlSymbol($purchase['balanceoutstanding'], $purchase['ordercurrency']).'</td></tr></table>';






    $body .= '</font></body></html>';
    $emailServices = new EmailServicesController();
    $emailServices->generateBatchEmail($to, $cc, $from, $fromName, $subject, $body, 'html', '');
}

}
?>