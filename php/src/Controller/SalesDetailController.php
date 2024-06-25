<?php

namespace App\Controller;

use Cake\Datasource\ConnectionManager;
use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use Cake\View\View;
use Cake\I18n\Time;
use Cake\View\Helper;
use App\View\Helper\ComponentStatusHelper;

/**
 * Customerservice Controller
 *
 * @property \App\Model\Table\ExportCollectionsTable $Exportcollections
 * @property \App\Model\Table\ExportCollShowroomTable $ExportcollShowroom
 * @method \App\Model\Entity\Customerservice[]|\Cake\Datasource\ResultSetInterface paginate($object = null, array $settings = [])
 */
class SalesDetailController extends SecureAppController
{
    private $page;
    private $userAdmin;
    
    public function initialize() : void {
        parent::initialize();
		//$this->loadComponent('Cookie');
		$this->loadComponent('SavoirSecurity');
		$this->loadComponent('Paginator');
        $this->loadModel("ExportCollections");
        //$this->loadHelper('ComponentStatus');
    }  
    public function index()
    {
        $this->viewBuilder()->setLayout('fabricstatus');
        $this->render('index');
    }

    public function plannedExports()
    {
        $dir = $this->request->getQuery("date","asc");

        //TODO: select and show joined record on view
        $ec = TableRegistry::get('exportcollections');
        $q = $ec->find("all",
            ['contain' =>
                ["location",
                    "SavoirUser",
                    "collectionStatus",
                    "ConsigneeAddress",
                    'ExportCollShowroom'=>
                    [   "location",
                        "ExportLinks"=>

                        [
                            "Purchase"=>
                            [
                                "Contact"=>["Address"]
                            ]
                        ]
                    ],
                    "ShipperAddress"
                ]
            ]
        )

            ->where(["collectionStatus !="=>4])
            ->where(["collectionStatus !="=>5]);

        if($dir == "asc"){
            $q->orderAsc("CollectionDate");
        }else{
            $q->orderDesc("CollectionDate");
        }
        //debug($q);
        $this->set("data2",$q);
        $this->viewBuilder()->setLayout('fabricstatus');
        $this->render('planned_exports');
    }

    private  function build_csv_row($handler,$row){
        // Showrooms section
        $locations = "";
        foreach ($row->export_coll_showroom as $s){
            $locations .= $s->location->adminheading.",";
        }
        $locations = trim($locations,",");

        // Collection date section
        $col_date = date_format(date_create($row->CollectionDate),"d/m/Y");

        // Eta date section
        $etas = "";
        foreach ($row->export_coll_showroom as $s){
            $etas .= date_format(date_create($s->ETAdate),"d/m/Y").",";
        }
        $etas = trim($etas,",");

        // Shipper section
        $shipper = $row->shipperName;

        // consignee section
        $consignee = $row->ConsigneeAddress != null ? $row->ConsigneeAddress->consigneeName:"";

        // Transport Mode section
        $transport_mode = $row->TransportMode;

        // Container reff section
        $container_reff = $row->ContainerRef;

        // Qty of order section
        $orderCount = 0;
        foreach ($row->export_coll_showroom as $s){
            if ($s->export_links!=null){
                foreach ($s->export_links as $l){
                    if ($l->orderConfirmed == "y") {
                        $orderCount++;
                    }
                }
            }
        }

        // items section
        $itemCount = 0;
        foreach ($row->export_coll_showroom as $s){
            if ($s->export_links!=null){
                foreach ($s->export_links as $l){
                    if ($l->orderConfirmed == "y") {
                        $itemCount++;
                    }
                }
            }
        }

        // Status section
        $status = $row->collection_status->collectionStatusName;

        $arr = [
            $locations,
            $col_date,
            $etas,
            $shipper,
            $consignee,
            $transport_mode,
            $container_reff,
            $orderCount,
            $itemCount,
            $status
        ];

        fputcsv($handler,$arr);
    }

    public function plannedExportsCsv(){
        $dir = $this->request->getQuery("date","asc");
        $ec = TableRegistry::get('exportcollections');
        $q = $ec->find("all",
            ['contain' =>
                ["location",
                    "SavoirUser",
                    "collectionStatus",
                    "ConsigneeAddress",
                    'ExportCollShowroom'=>
                        [   "location",
                            "ExportLinks"=>

                                [
                                    "Purchase"=>
                                        [
                                            "Contact"=>["Address"]
                                        ]
                                ]
                        ],
                    "ShipperAddress"
                ]
            ]
        )
            ->where(["collectionStatus <>"=>4])
            ->where(["collectionStatus <>"=>5]);

        if($dir == "asc"){
            $q->orderAsc("CollectionDate");
        }else{
            $q->orderDesc("CollectionDate");
        }

        // TODO: space for filter condition

        $this->autoRender = false;
        try{
            ini_set("error_reporting","0");
            header('Content-Type: application/csv');
            header('Content-Disposition: attachment; filename="planned-export.csv";');
            $f = fopen('php://output', 'w');

            $heading = [
                "Showrooms",
                "Collection Date",
                "Eta Date",
                "Shipper",
                "Consignee",
                "Transport Mode",
                "Container Reff",
                "Qty. of Order",
                "Items",
                "Status"
            ];
            fputcsv($f,$heading);

            foreach ($q as $row){
                $this->build_csv_row($f,$row);
            }
        }catch (\Exception $exception){}

    }

    public function cancelledExports()
    {

        $dir = $this->request->getQuery("date","asc");

        //TODO: select and show joined record on view

        $ec = TableRegistry::get('exportcollections');
        $q = $ec->find("all",
            ['contain' =>
                ["location",
                    "SavoirUser",
                    "collectionStatus",
                    "ConsigneeAddress",
                    'ExportCollShowroom'=>
                    [   "location",
                        "ExportLinks"=>

                        [
                            "Purchase"=>
                            [
                                "Contact"=>["Address"]
                            ]
                        ]
                    ],
                    "ShipperAddress"
                ]
            ]
        )

        ->where(["collectionStatus"=>5]);

        if($dir == "asc"){
            $q->orderAsc("CollectionDate");
        }else{
            $q->orderDesc("CollectionDate");
        }

        $this->set("data2",$q);
        $this->viewBuilder()->setLayout('fabricstatus');
        $this->render('cancelled_exports');
    }

    public function cancelledExportsCsv(){
        $dir = $this->request->getQuery("date","asc");
        $ec = TableRegistry::get('exportcollections');
        $q = $ec->find("all",
            ['contain' =>
                ["location",
                    "SavoirUser",
                    "collectionStatus",
                    "ConsigneeAddress",
                    'ExportCollShowroom'=>
                        [   "location",
                            "ExportLinks"=>

                                [
                                    "Purchase"=>
                                        [
                                            "Contact"=>["Address"]
                                        ]
                                ]
                        ],
                    "ShipperAddress"
                ]
            ]
        )
            ->where(["collectionStatus"=>5]);

        if($dir == "asc"){
            $q->orderAsc("CollectionDate");
        }else{
            $q->orderDesc("CollectionDate");
        }

        // TODO: space for filter condition

        $this->autoRender = false;
        try{
            ini_set("error_reporting","0");
            header('Content-Type: application/csv');
            header('Content-Disposition: attachment; filename="planned-export.csv";');
            $f = fopen('php://output', 'w');

            $heading = [
                "Showrooms",
                "Collection Date",
                "Eta Date",
                "Shipper",
                "Consignee",
                "Transport Mode",
                "Container Reff",
                "Qty. of Order",
                "Items",
                "Status"
            ];
            fputcsv($f,$heading);

            foreach ($q as $row){
                $this->build_csv_row($f,$row);
            }
        }catch (\Exception $exception){}

    }

    public function deliveredExports()
    {
        $dir = $this->request->getQuery("date","desc");

        //TODO: select and show joined record on view

        $ec = TableRegistry::get('exportcollections');
        $q = $ec->find("all",
            ['contain' =>
                ["location",
                    "SavoirUser",
                    "collectionStatus",
                    "ConsigneeAddress",
                    'ExportCollShowroom'=>
                        [   "location",
                            "ExportLinks"=>

                                [
                                    "Purchase"=>
                                        [
                                            "Contact"=>["Address"]
                                        ]
                                ]
                        ],
                    "ShipperAddress"
                ]
            ]
        )

            ->where(["collectionStatus"=>4]);

        if($dir == "asc"){
            $q->orderAsc("CollectionDate");
        }else{
            $q->orderDesc("CollectionDate");
        }

        $this->set("data2",$q);
        $this->viewBuilder()->setLayout('fabricstatus');
        $this->render('delivered_exports');
    }

    public function deliveredExportsCsv(){
        $dir = $this->request->getQuery("date","asc");
        $ec = TableRegistry::get('exportcollections');
        $q = $ec->find("all",
            ['contain' =>
                ["location",
                    "SavoirUser",
                    "collectionStatus",
                    "ConsigneeAddress",
                    'ExportCollShowroom'=>
                        [   "location",
                            "ExportLinks"=>

                                [
                                    "Purchase"=>
                                        [
                                            "Contact"=>["Address"]
                                        ]
                                ]
                        ],
                    "ShipperAddress"
                ]
            ]
        )
            ->where(["collectionStatus"=>4]);

        if($dir == "asc"){
            $q->orderAsc("CollectionDate");
        }else{
            $q->orderDesc("CollectionDate");
        }

        // TODO: space for filter condition

        $this->autoRender = false;
        try{
            ini_set("error_reporting","0");
            header('Content-Type: application/csv');
            header('Content-Disposition: attachment; filename="delivered-export.csv";');
            $f = fopen('php://output', 'w');

            $heading = [
                "Showrooms",
                "Collection Date",
                "Eta Date",
                "Shipper",
                "Consignee",
                "Transport Mode",
                "Container Reff",
                "Qty. of Order",
                "Items",
                "Status"
            ];
            fputcsv($f,$heading);

            foreach ($q as $row){
                $this->build_csv_row($f,$row);
            }
        }catch (\Exception $exception){}
    }

    public function createOrder()
    {
        $shipper_address_table = TableRegistry::get("shipper_address");
        $locations = TableRegistry::get("location");

        $this->set("shipper_addresses",$shipper_address_table->find());
        $this->set("locations",$locations->find()->where([
            "retire"=>"n"
        ])->orderAsc("adminheading"));
        $this->viewBuilder()->setLayout('fabricstatus');
        $this->render('create_order');
    }

    public function editOrder($id=null)
    {
        $id = $id == null ? $this->request->getQuery("id"):$id;
        $shipper_address_table = TableRegistry::get("shipper_address");
        $locations = TableRegistry::get("location");
        $ec = TableRegistry::getTableLocator()->get("exportcollections");
        $ec->setTable("exportCollections");
        $ec->setPrimaryKey("exportCollectionsID");
        $ec->hasMany('ExportCollShowroom')->setForeignKey('exportCollectionID')->setJoinType('LEFT')->setBindingKey('exportCollectionsID');




        $ec = $ec->get($id,[
            "contain" => [
                'ExportCollShowroom'=>[
                    "location"
                ]
            ]
        ]);


        $this->set("shipper_addresses",$shipper_address_table->find());
        $this->set("locations",$locations->find()->where([
            "retire"=>"n"
        ])->orderAsc("adminheading"));
        $this->set("data",$ec);
        $this->set("location_ids",$this->location_ids($ec));
        $this->set("ed",$this->setEd($ec));
        $this->viewBuilder()->setLayout('fabricstatus');
        $this->render('edit_order');
    }

    private function location_ids($ec){
        $data = [];
        if(isset($ec)){
            foreach ($ec->export_coll_showroom as $es){
                $data[] = $es->location->idlocation;
            }
        }

        return $data;
    }

    private function setEd($ec){
        $data = [];
        if(isset($ec)){
            foreach ($ec->export_coll_showroom as $es){
                $data[$es->idLocation] = $es->ETAdate;
            }
        }
        return $data;
    }

    private function build_eta($eta_dates){
        $data = [];

        foreach (array_filter($eta_dates) as $x){
            $data[] = $x;
        }
        return $data;
    }

    public function createOrderSubmit(){
        $collectionstatus = $this->request->getData("collectionstatus","");
        $collectionid = $this->request->getData("collectionid","");
        $amend= $this->request->getData("amend","");
        $addcollection = $this->request->getData("addcollection","");
        $locations = $this->request->getData("location_ids",[]);
        $etadate = $this->build_eta($this->request->getData("eta_date"));
        $collectiondate = $this->request->getData("collection-date","");
        $shipperaddress = $this->request->getData("shipper_address_id","");
        $transportmode = $this->request->getData("transport_mode","");
        $containerref = $this->request->getData("container_ref","");

        $userid = $this->Auth ? $this->Auth->user()["User"]["id"]:1; //TODO: make sure user id


        $ec = TableRegistry::getTableLocator()->get("ExportCollectionsTable");
        $ec->setTable("exportCollections");
        $ec->setPrimaryKey("exportCollectionsID");

        if($addcollection != ""){

            if($amend == "y"){
                $e_obj = $ec->updateAll([
                    "CollectionDate" => Time::createFromFormat("d/m/Y",$collectiondate)->format("Y-m-d"),
                    "Shipper" => $shipperaddress,
                    "TransportMode" => $transportmode,
                    "ContainerRef" => $containerref,
                    "dateAdded" => Time::parse()->format("Y-m-d H:i:s"),
                    "AddedBy" => $userid,
                    "collectionStatus" => $collectionstatus
                ],["exportCollectionsID"=>$collectionid]);
            }else{
                $e_obj = $ec->query()->insert(["CollectionDate","Shipper","TransportMode","ContainerRef","dateAdded","AddedBy","collectionStatus"])
                    ->values([
                        "CollectionDate" => Time::createFromFormat("d/m/Y",$collectiondate)->format("Y-m-d"),
                        "Shipper" => $shipperaddress,
                        "TransportMode" => $transportmode,
                        "ContainerRef" => $containerref,
                        "dateAdded" => Time::parse()->format("Y-m-d H:i:s"),
                        "AddedBy" => $userid,
                        "collectionStatus" =>1
                    ])->execute();
                $collectionid = $e_obj->lastInsertId(); //TODO: get lst insert id
            }

            if($collectionstatus == 5){
                $el = TableRegistry::getTableLocator()->get("ExportLinksTable");
                $el->setTable('exportlinks');
                $el->setPrimaryKey('exportLinksID');

                $el_obj = $el->find()->where(["linkCollectionId"=>$collectionid]);
                $el_obj->delete();
            }

            if($amend != "y"){
                $ecs = TableRegistry::getTableLocator()->get("ExportCollShowroomTable");
                $ecs->setTable('exportcollshowrooms');
                $ecs->setPrimaryKey('exportCollshowroomsID');

                $ecs_obj = $ecs->find()->where(["exportCollectionID"=>$collectionid]);
                $ecs_obj->delete();

                if($collectionstatus != 5){
                    foreach ($locations as $k=>$location){
                        foreach (array_filter($etadate) as $k2=>$eta){
                            if($k == $k2){
                                $data = [
                                    "exportCollectionID" => $collectionid,
                                    "idLocation" => $location,
                                    "ETAdate" => Time::createFromFormat("d/m/Y",$eta)->format("Y-m-d")
                                ];


                                $x = $ecs->query()->insert(["exportCollectionID","idLocation","ETAdate"])->values($data)->execute();
                            }
                        }
                    }
                }
            }

            if($amend == "y"){
                $ecs = TableRegistry::getTableLocator()->get("ExportCollShowroomTable");
                $ecs->setTable('exportcollshowrooms');
                $ecs->setPrimaryKey('exportCollshowroomsID');

                if($collectionstatus != 5){
                    foreach ($locations as $k=>$location){
                        foreach ($etadate as $k2=>$eta){
                            if($k == $k2){
                                $ecs_obj = $ecs->find()->where(["exportCollectionID"=>"$collectionid","idLocation"=>$location]);
                                if($ecs_obj->count() > 0){
                                    $ecs->updateAll([
                                        "etadate" => Time::createFromFormat("d/m/Y",$eta)->format("Y-m-d")
                                    ],["exportCollectionID"=>"$collectionid","idLocation"=>$location]);

                                    //TODO: reveal redim preserve showroomarray(count) on asp
                                    //TODO: reveal showroomarray(count)=id on asp
                                }else{
                                    $ecs->query()->insert(["exportCollectionID","idLocation","ETAdate"])->values([
                                        "exportCollectionID" => $collectionid,
                                        "idLocation" => $location,
                                        "ETAdate" => Time::createFromFormat("d/m/Y",$eta)->format("Y-m-d")
                                    ])->execute();
                                }
                            }
                        }
                    }
                }
            }
        }

        $this->redirect("/sales-detail/planned-exports");


    }

    public function containerDetail()
    {
        
        if ($this->request->is('get')) {
            $request = $this->request->getQuery();
            $id = (int)$request['id'];
            $ComponentStatus = new ComponentStatusHelper(new \Cake\View\View());
            //var_dump($id);
            $purchaseNo = [];
            $Exportcollections = TableRegistry::get('exportcollections');
            $exportCollection = $Exportcollections->get($id,['contain' => 
                ["location", 
                "SavoirUser", 
                "collectionStatus", 
                'ExportCollShowroom'=>[
                    "ExportLinks"=>[
                        "Purchase"=>[
                            "Contact"=>["Address"]
                        ]
                    ],
                    "location"
                ],
                "ShipperAddress"]
            ]);
            foreach ($exportCollection->export_coll_showroom as $showrooms) {
                foreach ($showrooms->export_links as $links) {
                    if (!in_array($links->purchase_no, $purchaseNo)) {
                        $purchaseNo[] = $links->purchase_no;
                    }
                }
                
            }
            $orderDetails= $ComponentStatus->orderDetail($id);
            /*if(!in_array($value, $a)){
                $a[]=$value;
            }*/
        }
        $this->set(compact('exportCollection' , 'orderDetails'));
        $this->viewBuilder()->setLayout('fabricstatus');
        $this->render('container_detail');
    }

    public function export()
    {
        $ComponentStatus = new ComponentStatusHelper(new \Cake\View\View());
        if ($this->request->is('get')) {
            $request = $this->request->getQuery();
            $id = (int)$request['id'];
            
            $Exportcollections = TableRegistry::get('exportcollections');
            $exportCollection = $Exportcollections->get($id,['contain' => 
                ["location", 
                "SavoirUser", 
                "collectionStatus", 
                'ExportCollShowroom'=>[
                    "ExportLinks"=>[
                        "Purchase"=>[
                            "Contact"=>["Address"]
                        ]
                    ],
                    "location"
                ],
                "ShipperAddress"]
            ]);
            $csvArray = [];
            $csvArray[] = ["SALES"];
            
            if ($exportCollection != null) { 
                if (count($exportCollection->export_coll_showroom)>0) {
                    foreach ($exportCollection->export_coll_showroom as $exportcollshowrooms) {
                        
                        if ($exportcollshowrooms->location != null) {
                            //var_dump($exportcollshowrooms->location);
                            $csvArray[] =  [$exportcollshowrooms->location->location];
                        } else {
                            $csvArray[] =  "";
                        }
                        $csvArray[] = ["Order No", "Customer Name","Customer Reference","Order Description","Total Amount","Invoice No.","Shipped","Payment Received","Payment Due"];   
                        $orderDetails= $ComponentStatus->orderDetail($id);
                        $total = 0;
                        $productDetail = "";
                        if (count($orderDetails)>0) {
                            foreach ($orderDetails as $details) { 
                                    //debug($details);
                                    //cho '<pre>' . var_export($exportcollshowrooms->export_links) . '</pre>';
                                if ($exportcollshowrooms->location->idlocation == $details['idLocation']) {
                                    if ($details['savoirmodel'] != null) {
                                        $productDetail.=$details['savoirmodel']. " mattress, ";
                                    }
                                    if ($details['basesavoirmodel']) {
                                        $productDetail.=$details['basesavoirmodel']. " base, ";
                                    }
                                    if ($details['toppertype']) {
                                        
                                        $productDetail.=$details['toppertype']." Valance, ";
                                    }
                                    if ($details['valancerequired'] == "y") {
                                        $productDetail.=" Valance, ";
                                    }
                                    if ($details['legsrequired'] == "y") {
                                        $productDetail.=" Legs, ";
                                    }
                                    if ($details['headboardrequired'] == "y") {
                                        $productDetail.=" Headboard, ";
                                    }

                                    $total += $details['bedsettotal'];
                            
                            
                                    $single = [h($details['ORDER_NUMBER']), 
                                    $details['surname']." ".$details['first']." ".$details['title'], 
                                    h($details['customerreference']), 
                                    h($productDetail), 
                                    h("£".number_format($details['bedsettotal'],2)), 
                                    h($details['InvoiceNo']),
                                    Time::parse($details['deliverydate'])->i18nFormat('dd/MM/yyyy'), 
                                    h("£".number_format($details['paymentstotal'],2)),
                                    h("£".number_format($details['balanceoutstanding'],2))
                                    ];
                                    $csvArray[] = $single;
                                }
                            }
                        }
                        
                        
                    }
                }
            }
            $_header = [];
        
            error_reporting(0);
            $this->setResponse($this->getResponse()->withDownload('container-detail.csv'));
	    	$this->set(compact('csvArray'));
	    	$this->viewBuilder()
	    	->setClassName('CsvView.Csv')
	    	->setOptions([
	            'serialize' => 'csvArray',
	            'header' => $header
	    	]);
        }
    }

    protected function _getAllowedRoles()
    {
        return array("ADMINISTRATOR","SALES");
    }
}

?>