{*
* 2007-2014 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2014 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}

<link rel="stylesheet" href="{$shop_url}/modules/tntcarrier/css/ui.tabs.css" type="text/css" />
<link rel="stylesheet" href="{$shop_url}/modules/tntcarrier/css/ui.dialog.css" type="text/css" />

<script type="text/javascript">
var id_carrier = new Array();
var option_carrier = new Array();
var date_carrier = new Array();
var i = 0;
{foreach from=$services item=foo}
id_carrier[i] = '{$foo.id_carrier}';
option_carrier[i] = '{$foo.option}';
date_carrier[{$foo.id_carrier}] = '{$dueDate[$foo.id_carrier]}';
i++;
{/foreach}

{if $version < '1.5'}
{literal}
$().ready(function()
{
	$("[id*='id_carrier']").each(function(){
			var id_array = $(this).val();
			var indexTab = jQuery.inArray(id_array, id_carrier);
			if (indexTab >= 0)
			{
				if(option_carrier[indexTab].length > 1)
				{
					if (option_carrier[indexTab].charAt(1) == 'Z')
						$("#id_carrier"+$(this).val()).parent().parent().children(".carrier_infos").append("<br/><span onclick=\'displayHelpCarrier(\"https://www.tnt.fr/BtoC/page_domicile.html\")\' style=\'font-style:italic;cursor:pointer;color:blue;text-decoration:underline\'>+ d\'infos</span>");
					else if (option_carrier[indexTab].charAt(1) == 'D')
						$("#id_carrier"+$(this).val()).parent().parent().children(".carrier_infos").append("<br/><span onclick=\'displayHelpCarrier(\"https://www.tnt.fr/BtoC/page_relais-colis.html\")\' style=\'font-style:italic;cursor:pointer;color:blue;text-decoration:underline\'>+ d\'infos</span>");

					else
						$("#id_carrier"+$(this).val()).parent().parent().children(".carrier_infos").append("<br/><span onclick=\'displayHelpCarrier(\"https://www.tnt.fr/BtoC/page_popup.html\")\' style=\'font-style:italic;cursor:pointer;color:blue;text-decoration:underline\'>+ d\'infos</span>");
				}
				else
					$("#id_carrier"+$(this).val()).parent().parent().children(".carrier_infos").append("<br/><span onclick=\'displayHelpCarrier(\"https://www.tnt.fr/BtoC/page_popup.html\")\' style=\'font-style:italic;cursor:pointer;color:blue;text-decoration:underline\'>+ d\'infos</span>");
			}
		});
});

$("input[name='id_carrier']").click(function() {
    var idcarrier = $(this).val();
    if (date_carrier[idcarrier] != undefined)
    {
	var idCart = document.getElementById("cartRelaisColis").value;
	$.ajax({
	    type: "POST",
	    url: "{/literal}{$shop_url}{literal}/modules/tntcarrier/relaisColis/postRelaisData.php",
	    data: "id_cart="+idCart+"&due_date="+date_carrier[idcarrier]
	});
    }
    getAjaxRelais($("input[name='id_carrier']:checked").val());
    if (document.getElementById("tr_carrier_relais"))
    {
        var node = document.getElementById("tr_carrier_relais").parentNode;
        var father = node.parentNode;
        father.removeChild(node);
    }
});

function displayNewTable(response, id)
{
    var display = false
    for (x in id_carrier)
	if (id_carrier[x] == id)
	    display = true;
    if (!display)
	return false;
    $("#id_carrier"+id).parent().parent().after("<tr><td colspan='4' style='display:none' id='tr_carrier_relais'></td></tr>");
	$("#tr_carrier_relais").html(response);
    $("#tr_carrier_relais").slideDown('slow');
    tntRCInitMap();
    tntRCgetCommunes();
}

{/literal}
{else}
{literal}
	$(document).ready(function()
	{
		var chosenCarrier = $("input[name*='delivery_option[']:checked").val().split(',');
		getAjaxRelais(chosenCarrier[0]);
		$("[id*='delivery_option_']").each(function(){
			var id_array = $(this).val().split(',');
			var indexTab = jQuery.inArray(id_array[0], id_carrier);
			if (indexTab >= 0 && $("#tnt_popup"+id_array[0]).length <= 0)
			{
				if(option_carrier[indexTab].length > 1)
				{
					if (option_carrier[indexTab].charAt(1) == 'Z')
						$("[for='"+$(this).attr('id')+"'] .delivery_option_logo").append(" <span id=\'tnt_popup\' onclick=\'displayHelpCarrier(\"https://www.tnt.fr/BtoC/page_domicile.html\");return false;\' style=\'font-style:italic;cursor:pointer;color:blue;text-decoration:underline\'>+ d\'infos</span>");
					else if (option_carrier[indexTab].charAt(1) == 'D')
						$("[for='"+$(this).attr('id')+"'] .delivery_option_logo").append(" <span id=\'tnt_popup"+id_array[0]+"\' onclick=\'displayHelpCarrier(\"https://www.tnt.fr/BtoC/page_relais-colis.html\");return false;\' style=\'font-style:italic;cursor:pointer;color:blue;text-decoration:underline\'>+ d\'infos</span>");
					else
						$("[for='"+$(this).attr('id')+"'] .delivery_option_logo").append(" <span id=\'tnt_popup"+id_array[0]+"\' onclick=\'displayHelpCarrier(\"https://www.tnt.fr/BtoC/page_popup.html\");return false;\' style=\'font-style:italic;cursor:pointer;color:blue;text-decoration:underline\'>+ d\'infos</span>");
				}
				else
					$("[for='"+$(this).attr('id')+"'] .delivery_option_logo").append(" <span id=\'tnt_popup"+id_array[0]+"\' onclick=\'displayHelpCarrier(\"https://www.tnt.fr/BtoC/page_popup.html\");return false;\' style=\'font-style:italic;cursor:pointer;color:blue;text-decoration:underline\'>+ d\'infos</span>");
			}
		});
	});


	$("input[name='id_carrier']").click(function() {
		var idcarrier = $(this).val();
		if (date_carrier[idcarrier] != undefined)
		{
		var idCart = document.getElementById("cartRelaisColis").value;
		$.ajax({
			type: "POST",
			url: "{/literal}{$shop_url}{literal}/modules/tntcarrier/relaisColis/postRelaisData.php",
			data: "id_cart="+idCart+"&due_date="+date_carrier[idcarrier]
		});
		}
		getAjaxRelais($("input[name='id_carrier']:checked").val());
		if (document.getElementById("tr_carrier_relais"))
		{
			var node = document.getElementById("tr_carrier_relais").parentNode;
			var father = node.parentNode;
			father.removeChild(node);
		}
	});


	if ($('.opc-main-block').length == 0) {
		$("input[name*='delivery_option[']").click(function() {
			enableProcessCarrier();
			var id_array = $("input[name*='delivery_option[']:checked").val().split(',');
			if (document.getElementById("tr_carrier_relais"))
				$("#tr_carrier_relais").remove();
			getAjaxRelais(id_array[0]);
		});
	}

	function submitFormCmd()
	{
		hideNewShowCarrier();
	}

	function displayHelp()
	{
		var help = {link: false, text: false};

		if ($('#moreinformations').length){
			$('#moreinformations').remove();
		}
		$("#HOOK_BEFORECARRIER").after("<div id='moreinformations' style='margin-bottom:10px;'></div>");
		$("#moreinformations").html("<span id='tnt_popup' class='button btn'><a href='#'>Cliquez-ici</a></span>");

		if ($("#tntRCSelectedType").val() == 'JZ') {
			help['text'] = "Vous avez s&eacute;lectionn&eacute; la livraison TNT 24h à domicile, pour avoir plus d'informations ";
			help['link'] = "https://www.tnt.fr/BtoC/page_domicile.html"
		}
		else if ($("#tntRCSelectedType").val() == 'JD') {
			help['text'] = "Vous avez s&eacute;lectionn&eacute; la livraison TNT 24h Relais Colis®, pour avoir plus d'informations ";
			help['link'] = "https://www.tnt.fr/BtoC/page_relais-colis.html";
		}
		else if ($("#tntRCSelectedType").val() == 'J') {
			help['text'] = "Vous avez s&eacute;lectionn&eacute; la livraison TNT 24h au bureau, pour avoir plus d'informations ";
			help['link'] = "https://www.tnt.fr/BtoC/page_popup.html";
		}

		if (help['text'] !== false && help['link'] !== false) {
			$("#moreinformations").html(help['text'] + "<span id='tnt_popup' class='button btn'><a href='#'>Cliquez-ici</a></span>");
			$("#tnt_popup").click(function() {
				displayNewHelpCarrier(help['link']);
			});
		}
		else
			$('#moreinformations').remove();

	}

	function displayRelais()
	{
		$("#extra_carrier").after("<div id='relaisColis' style='margin-bottom:10px;'></div>");
		$("#relaisColis").html("Relais Colis s&eacute;lectionn&eacute; :<br/>" + $("#tntRCSelectedNom").val() + "<br/>" + $("#tntRCSelectedAdresse").val() + "<br/>" + $("#tntRCSelectedCodePostal").val() + " " + $("#tntRCSelectedCommune").val());
		$("#extra_carrier").css('display', 'block');
	}

	function displayNewTable(response, id)
	{
		$("#tntShowCarrier").hide();

		if ($('#tntShowCarrier').length){
			$('#tntShowCarrier').remove();
		}
		if ($('#moreinformations').length){
			$('#moreinformations').remove();
		}
		if ($('#relaisColis').length){
			$('#relaisColis').remove();
		}
		$( 'body' ).append("<div id='tntShowCarrier' style='display:none;'><div id='helpCarrierBlock' style='text-align:center;position:relative'><div style='border-radius:10px;width:930px;margin:auto;background-color:white;padding-top:10px;'><span class='button btn' onclick='hideNewShowCarrier(1)' style='float:right;margin-right:37px;'>{/literal}{l s='Close' mod='tntcarrier'}{literal}</span><br/><div id='tr_carrier_relais' style='width:920px;border:none;margin-top:5px;overflow-x:hidden;overflow-y:auto;'></div><div id='button_carrier_relais' style='padding-top:5px;padding-bottom:10px;'></p><a href='#' class='button btn' onclick='submitFormCmd()'>{/literal}{l s='Valider' mod='tntcarrier'}{literal}</a></div></div></div></div>");
		$("#tntShowCarrier").css('height', ($(document).height())+'px');
		$("#tntShowCarrier").css('width', $(document).width()+'px');
		$("#tntShowCarrier").css('background', 'url({/literal}{$shop_url}{literal}img/macFFBgHack.png)');
		$("#tntShowCarrier").css('position', 'absolute');
		$("#tntShowCarrier").css('top', '0px');
		$("#tntShowCarrier").css('z-index', '99999');
		$("#helpCarrierBlock").css('top', $(window).scrollTop()+'px');
		if ($(window).height() > 500)
		{
			var h = ($(window).height() - 720) / 2+'px';

			$("#helpCarrierBlock").css('margin-top', h);
		}
		else
			$("#HelpCarrierBlock").css('margin-top', '20px');

		$("#tr_carrier_relais").html(response);

		$("#tr_carrier_relais").css('padding', '4px');
		$("#tr_carrier_relais h3").css('margin', '0 -5px');
		tntRCInitMap();
		tntRCgetCommunes();

		if ($("#tntRCSelectedType").val() == 'JD' || $('#mobilenumber').length )
		{
			$("#tntShowCarrier").css('display','block');
		}

		var htr = 505;

		if($("#tr_carrier_relais").height() < htr)
			htr = $("#tr_carrier_relais").height() + 20;

		$("#tr_carrier_relais").css('height', htr+'px');

		displayHelp();
		if ($("#tntRCSelectedType").val() == 'JD')
			google.maps.event.trigger(map, 'resize');

	}

	function displayNewHelpCarrier(src)
	{
		$('#tntHelpCarrier').remove();
		$( 'body' ).append("<div id='tntHelpCarrier'><div id='helpCarrierBlock' style='text-align:center;position:relative'><div style='width:930px;margin:auto;background-color:white;border-radius:10px;'><span class='button btn' onclick='hideNewHelpCarrier()' style='float:right;margin-right:37px;'>{/literal}{l s='Close' mod='tntcarrier'}{literal}</span><br/><iframe id='helpCarrierFrame' style='height:500px;width:900px;border:none;margin-top:5px;overflow-x:hidden;overflow-y: scroll;'></iframe></div></div></div>");
		$("#tntHelpCarrier").css('height', $(document).height()+'px');
		$("#tntHelpCarrier").css('width', $(document).width()+'px');
		$("#tntHelpCarrier").css('background', 'url({/literal}{$shop_url}{literal}img/macFFBgHack.png)');
		$("#tntHelpCarrier").css('position', 'absolute');
		$("#tntHelpCarrier").css('top', '0px');
		$("#tntHelpCarrier").css('z-index', '99999');
		$("#helpCarrierFrame").attr('src', src);
		$("#helpCarrierBlock").css('top', $(window).scrollTop()+'px');
		if ($(window).height() > 500)
		{
			var h = ($(window).height() - 520) / 2+'px';

			$("#helpCarrierBlock").css('margin-top', h);
		}
		else
			$("#HelpCarrierBlock").css('margin-top', '20px');
	}

	function unselectCarrier()
	{
		$('input[name^=delivery_option]:checked').parent().removeClass('checked');
		$('button[name=processCarrier]').addClass('disabled');
	}

	function enableProcessCarrier()
	{
		$('button[name=processCarrier]').removeClass('disabled');
	}


	function hideNewShowCarrier(close)
	{
		close = typeof close !== 'undefined' ? close : false;

		if($("#tntRCSelectedType").val() == 'JD' && !$('[name=tntRCchoixRelais]:checked').length)
		{

			if (close)
			{
				unselectCarrier();
				$("#tntShowCarrier").hide();
				displayHelp();
				if ($("#tntRCSelectedType").val() == 'JD')
					displayRelais();
			}
			else
			{
				tntRCgetRelaisColis();
			}
		}
		else if($('#mobilenumber').length && $('#mobileTnt').val().length < 10)
		{
			if (close)
			{
				unselectCarrier();
				$("#tntShowCarrier").hide();
				displayHelp();
				if ($("#tntRCSelectedType").val() == 'JD')
					displayRelais();
			}
			else
				alert('Veuillez saisir un numéro de téléphone portable !');
		}
		else
		{
			$("#tntShowCarrier").hide();
			displayHelp();
			if ($("#tntRCSelectedType").val() == 'JD')
			{
				displayRelais();
			}
		}
	}

	function hideNewHelpCarrier()
	{
		$("#tntHelpCarrier").hide();
{/literal}
	}
{/if}
{literal}
	function getAjaxRelais(id)
	{
		$.get(
			"{/literal}{$shop_url}{literal}/modules/tntcarrier/relaisColis.php?id_carrier="+id+"&idcart="+$("#cartRelaisColis").val(),
			function(response, status, xhr)
			{

				if (status == "error")
					$("#tr_carrier_relais").html(xhr.status + " " + xhr.statusText);
				$("#loadingRelais"+id).hide();
				if (status == 'success' && response != '' && response != 'none')
				{
					displayNewTable(response, id);
				}
			}
		);
	}

	function displayHelpCarrier(src)
	{
		$("#tntHelpCarrier").css('height', $(document).height()+'px');
		$("#helpCarrierFrame").attr('src', src);
		$("#helpCarrierBlock").css('top', $(window).scrollTop()+'px');
		if ($(window).height() > 500)
		{
			var h = ($(window).height() - 520) / 2+'px';

			$("#helpCarrierBlock").css('margin-top', h);
		}
		else
			$("#HelpCarrierBlock").css('margin-top', '20px');
		$(".opc-main-block").css('position', 'static');
		$("#tntHelpCarrier").show();
	}

	function hideHelpCarrier()
	{
		$("#tntHelpCarrier").hide();
		$(".opc-main-block").css('position', 'relative');
	}

	function selectCities(token)
	{
		$.get(
			"{/literal}{$shop_url}{literal}/modules/tntcarrier/changeCity.php?city="+$("#citiesGuide").val()+"&id="+$("#cartRelaisColis").val()+"&token="+token,
			function(response, status, xhr)
			{
				if (status == 'success' && response != 'none')
				{
					window.location.href = $("#reload_link").val();
				}
				else
					return false;
			}
		);
	}
{/literal}
</script>
{if $version < '1.6'}
<div id="tntHelpCarrier" style="display:none;position:absolute;width:100%;top:0px;left:0px;background:url('{$shop_url}img/macFFBgHack.png');z-index:10000">
	<div id="helpCarrierBlock" style="text-align:center;position:relative">
		<div style="width:720px;margin:auto;background-color:white">
		<span style="cursor:pointer;color:blue;text-decoration:underline;" onclick="hideHelpCarrier(1)">{l s='Close' mod='tntcarrier'}</span><br/>
		<iframe id="helpCarrierFrame" style="height:500px;width:700px;border:none;margin-top:5px">
		</iframe>
		</div>
	</div>
</div>
{/if}
<input type="hidden" id="cartRelaisColis" value="{$id_cart}" name="cartRelaisColis" />

{if isset($error)}
{if isset($cityError)}
<div style="background-color: #FAE2E3;border: 1px solid #EC9B9B;line-height: 20px;margin: 0 0 10px;padding: 10px 15px;">{$cityError}</div>
{else}
	<h3>{$error}</h3>
	{l s='Postal Code' mod='tntcarrier'} : {$postalCode}
	<select id="citiesGuide" style="width:130px" onchange="selectCities('{$tnt_token}')">
		<option selected="selected">{l s='Choose' mod='tntcarrier'}</option>
	 {foreach from=$cities item=v}
		<option value='{$v}'>{$v}</option>
	 {/foreach}
	</select>
	{if isset($link)}
	<input type="hidden" value="{$redirect}" id="reload_link" name="reload_link"/>
	{/if}
{/if}
{/if}
