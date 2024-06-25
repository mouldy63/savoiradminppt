<?php namespace App\View\Helper;

use Cake\View\Helper;
use Cake\I18n\Time;
use Cake\Datasource\ConnectionManager;
use Cake\ORM\TableRegistry;
class ComponentStatusHelper extends Helper
{
    public $helpers = ['Html'];

    public function colourise($value, $purchaseNo, $collectionDate, $links, $idLocation, $exportCollectionID,   $componentId)
    {
        // Use the HTML helper to output
        // Formatted data:
        $isPresent = false;
        foreach ($links as $link) {
            //var_dump($link->componentID);
            if ($link->componentID == $componentId) {
                $isPresent = true;
            }
        }
        $qc_history_latests = TableRegistry::get('qc_history');
        $qc_history_latest = $qc_history_latests->find("all",[
            'conditions' => [
                'ComponentID'=>$componentId,
                "Purchase_No"=>$purchaseNo
            ],
            'contain' => 
                ["qc_status"]
            ])->order(['QC_Date' => 'DESC'])->first();
        $colour = "";
        
        //var_dump($qc_history_latest);
        if ($qc_history_latest != null) {
            //var_dump($qc_history_latest->QC_StatusID);
            if ($qc_history_latest->QC_StatusID == 20){
                $colour = "red";
            } else if ($qc_history_latest->QC_StatusID == 30){
                $colour = "orange";
            } else if ($qc_history_latest->QC_StatusID == 40){
                $colour = "green";
            }else if ($qc_history_latest->QC_StatusID == 50){
                $colour = "green";
            }
            else if ($qc_history_latest->QC_StatusID == 60){
                $colour = "green";
            }
            else if ($qc_history_latest->QC_StatusID == 70){
                $colour = "gray";
            }

        }
        if ($isPresent) {
            return '<span class="'.$colour.'">' . $value . '</span>';
        } else {
            $ec = TableRegistry::get('exportlinks');
            $q = $ec->find("all",
            ['contain' =>

                [
                    "ExportCollShowroom",
                    "Purchase"=>
                    [
                        "Contact"=>["Address"]
                    ]
                ]
                   
            ]
            )
                ->where(["exportlinks.PURCHASE_No ="=>$purchaseNo])
                ->where(["exportlinks.componentID ="=>$componentId])
                ->first();
            //var_dump ($q);
            if ($q != null) {
                return"<a href='/shipment-details.asp?location=".$idLocation."&id=".$q->export_coll_showroom->exportCollectionID."'>".Time::parse($collectionDate)->i18nFormat('dd/MM/yyyy')."</a>";
            } else {
                return "";
            }
        }
    }
    public function countOrderQty($idLocation, $exportCollectionID)
    {
        $connection = ConnectionManager::get('default');
        $results = $connection->execute('SELECT count(distinct (E.purchase_no)) as tot, exportCollectionID, S.idlocation, L.adminheading 
        from exportlinks E, exportCollShowrooms S, location L  where E.LinksCollectionID=S.exportCollshowroomsID and L.idLocation=S.idLocation 
        and S.exportCollectionID=:exportCollectionID AND orderConfirmed="y" AND S.idlocation = :idLocation group by idlocation',['idLocation' => $idLocation, "exportCollectionID"=>$exportCollectionID]
        )->fetchAll('assoc');
        if (count($results)>0) {
            return $results[0]["tot"];
        } else {
            return 0;
        }
        

    }
    public function countItemQty($exportCollectionID, $exportCollshowroomsID)
    {
        $connection = ConnectionManager::get('default');
        $results = $connection->execute('SELECT componentID, P.purchase_no, P.mattresstype, P.basetype from exportLinks L, exportcollshowrooms S, purchase P 
        where L.LinksCollectionID=S.exportCollshowroomsID and L.purchase_no=P.purchase_no  
        and S.exportCollectionID=:exportCollectionID and s.exportCollshowroomsID=:exportCollshowroomsID and orderConfirmed = "y"',
        [ "exportCollectionID"=>$exportCollectionID, "exportCollshowroomsID"=>$exportCollshowroomsID]
        )->fetchAll('assoc');
        $itemCount = count($results);
       // var_dump($results);
        foreach ($results as $result) {
            if ($result["componentID"] == 1 && strpos($result["mattresstype"], 'Zip') !== false) {
                $itemCount++;
                //var_dump($l->purchase->mattresstype);
            }
            if ($result["componentID"] == 3 && (strpos($result["basetype"], 'Eas') !== false or strpos($result["basetype"], 'Nor') !== false)) {
                $itemCount++;
                //var_dump($l->purchase->basetype);
            }
        }
        return $itemCount;

    }
    public function countItemQtyDetails($exportCollectionID, $exportCollshowroomsID, $purchaseNo)
    {
        $connection = ConnectionManager::get('default');
        $results = $connection->execute('select e.collectiondate,e.exportcollectionsid, S.idlocation, l.componentid, P.*  
        from exportlinks l, exportcollections e, exportcollshowrooms S, purchase P   
        where l.purchase_no=:purchaseNo and S.exportCollectionID=:exportCollectionID and s.exportCollshowroomsID=:exportCollshowroomsID and L.purchase_no=P.purchase_no and l.linkscollectionid=S.exportCollshowroomsID and 
        S.exportCollectionID=e.exportcollectionsid and orderConfirmed = "y"',
        [ "exportCollectionID"=>$exportCollectionID, "exportCollshowroomsID"=>$exportCollshowroomsID, "purchaseNo"=>$purchaseNo]
        )->fetchAll('assoc');
        $itemCount = count($results);
       // var_dump($results);
        foreach ($results as $result) {
            if ($result["componentid"] == 1 && strpos($result["mattresstype"], 'Zip') !== false) {
                $itemCount++;
                //var_dump($l->purchase->mattresstype);
            }
            if ($result["componentid"] == 3 && (strpos($result["basetype"], 'Eas') !== false or strpos($result["basetype"], 'Nor') !== false)) {
                $itemCount++;
                //var_dump($l->purchase->basetype);
            }
        }
        return $itemCount;

    }

    public function orderDetail($exportCollectionID)
    {
        $connection = ConnectionManager::get('default');
        $results = $connection->execute('SELECT * from purchase P, contact C, address A, exportLinks E, exportcollshowrooms S 
        where E.LinksCollectionID=S.exportCollshowroomsID and P.purchase_no=E.purchase_no and P.code=C.code and 
        A.code=P.code and S.Exportcollectionid=:exportCollectionID group by E.purchase_no order by ORDER_NUMBER DESC',
        [ "exportCollectionID"=>$exportCollectionID]
        )->fetchAll('assoc');
        /*$itemCount = count($results);
       // var_dump($results);
        foreach ($results as $result) {
            if ($result["componentID"] == 1 && strpos($result["mattresstype"], 'Zip') !== false) {
                $itemCount++;
                //var_dump($l->purchase->mattresstype);
            }
            if ($result["componentID"] == 3 && (strpos($result["basetype"], 'Eas') !== false or strpos($result["basetype"], 'Nor') !== false)) {
                $itemCount++;
                //var_dump($l->purchase->basetype);
            }
        }*/
        //debug($results);
        return $results;

    }

}
?>