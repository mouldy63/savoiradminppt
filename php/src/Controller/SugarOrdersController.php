<?php
namespace App\Controller;

use Cake\I18n\Time;
use Cake\I18n\FrozenTime;
use Exception;
use \App\Controller\Component\UtilityComponent;

class SugarOrdersController extends AppController {

	public function initialize() : void {
        parent::initialize();
        $this->loadModel('Purchase');
        $this->loadComponent('JwtHelper');
        $this->loadComponent('Comreg');
	}

    public function viewClasses(): array {
        return [JsonView::class];
    }

    public function index() {
        if (!$this->JwtHelper->validateSugarJwt($this->Comreg)) {
            $this->autoRender = false;
            $response = [
                "error" => "invalid_token",
                "error_description" => "The provided JWT is invalid or has expired"
            ];
            header('Content-Type: application/json');
            echo json_encode($response);
            $this->response = $this->response->withStatus(401);
            return;
        }
        
        $ts = $this->request->getQuery('ts');
        $fromDateTime = FrozenTime::createFromTimestamp($ts);

        $latestOrders = $this->Purchase->getOrdersAmendedFrom($fromDateTime->format('Y-m-d H:i:s'));
        $latestOrdersArray = [];
        foreach ($latestOrders as $order) {
            $orderObj = [];
            $orderObj['ORDER No'] = $order['ORDER_NUMBER'];
            $orderObj['Purchase No'] = $order['PURCHASE_No'];
            $orderObj['ORDER DATE'] = $order['ORDER_DATE'];
            $orderObj['Expected Delivery Date'] = $order['deliverydate'];
            $orderObj['Amended Date'] = $order['AmendedDate'];
            $orderObj['Contact No'] = $order['contact_no'];
            if (empty($order['deliveryadd1']) && empty($order['deliverytown']) && empty($order['deliverycountry'])) {
                $orderObj['Delivery Address Line 1'] = $order['street1'];
                $orderObj['Delivery Address Line 2'] = $order['street2'];
                $orderObj['Delivery Address Line 3'] = $order['street3'];
                $orderObj['Delivery Address Town'] = $order['town'];
                $orderObj['Delivery Address County'] = $order['county'];
                $orderObj['Delivery Address Postcode'] = $order['postcode'];
                $orderObj['Delivery Address Country'] = $order['country'];
            } else {
            $orderObj['Delivery Address Line 1'] = $order['deliveryadd1'];
            $orderObj['Delivery Address Line 2'] = $order['deliveryadd2'];
            $orderObj['Delivery Address Line 3'] = $order['deliveryadd3'];
            $orderObj['Delivery Address Town'] = $order['deliverytown'];
            $orderObj['Delivery Address County'] = $order['deliverycounty'];
            $orderObj['Delivery Address Postcode'] = $order['deliverypostcode'];
            $orderObj['Delivery Address Country'] = $order['deliverycountry'];
            }
            $orderObj['Order Type'] = $order['ordertype'];
            $orderObj['Whole Order Status'] = $order['QC_status'];
            $orderObj['Total Ex Vat'] = $order['totalexvat'];
            $orderObj['Vat'] = $order['vat'];
            $orderObj['Currency'] = $order['ordercurrency'];
            $orderObj['Location'] = $order['idlocation'];
            array_push($latestOrdersArray, $orderObj);
        }

        $this->set('orders', $latestOrdersArray);
        $this->viewBuilder()->setOption('serialize', ['orders']);
    }

}
?>