select contact_no from contact where surname like 'test' and first like 'test' 

delete from communication where code in (select code from contact where surname like 'test' and first like 'test' ) ;
delete from interestproductslink where contact_no in (select contact_no from contact where surname like 'test' and first like 'test' ) ;
delete from address where code in (select code from contact where surname like 'test' and first like 'test' ) ;


delete from comp_price_discount where purchase_no in (select purchase_no from purchase where contact_no in (select contact_no from contact where surname like 'test' and first like 'test'));
delete from exportlinks where purchase_no in (select purchase_no from purchase where contact_no in (select contact_no from contact where surname like 'test' and first like 'test'));
delete from orderaccessory where purchase_no in (select purchase_no from purchase where contact_no in (select contact_no from contact where surname like 'test' and first like 'test'));
delete from orderhistory where purchase_no in (select purchase_no from purchase where contact_no in (select contact_no from contact where surname like 'test' and first like 'test'));
delete from ordernote where purchase_no in (select purchase_no from purchase where contact_no in (select contact_no from contact where surname like 'test' and first like 'test'));
delete from payment where purchase_no in (select purchase_no from purchase where contact_no in (select contact_no from contact where surname like 'test' and first like 'test'));
delete from phonenumber where purchase_no in (select purchase_no from purchase where contact_no in (select contact_no from contact where surname like 'test' and first like 'test'));
delete from production where purchase_no in (select purchase_no from purchase where contact_no in (select contact_no from contact where surname like 'test' and first like 'test'));
delete from productionsizes where purchase_no in (select purchase_no from purchase where contact_no in (select contact_no from contact where surname like 'test' and first like 'test'));
delete from purchase_attachment where purchase_no in (select purchase_no from purchase where contact_no in (select contact_no from contact where surname like 'test' and first like 'test'));
delete from purchase_shipper where purchase_no in (select purchase_no from purchase where contact_no in (select contact_no from contact where surname like 'test' and first like 'test'));
delete from qc_history where purchase_no in (select purchase_no from purchase where contact_no in (select contact_no from contact where surname like 'test' and first like 'test'));
delete from qc_history_latest where purchase_no in (select purchase_no from purchase where contact_no in (select contact_no from contact where surname like 'test' and first like 'test'));


delete from purchase where contact_no in (select contact_no from contact where surname like 'test' and first like 'test' );
delete from contact where surname like 'test' and first like 'test';