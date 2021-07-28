--
-- Created by IntelliJ IDEA.
-- User: zhenhuifu
-- Date: 2021/7/28
-- Time: 3:10 下午
-- To change this template use File | Settings | File Templates.
--

--local regexp = '<#([^\r\n<>]+)#>'
local regexp = "(<#|&lt;)([^\r\n<>]+)(#>|&gt;)";

local function print_ret(findsub, i, j, substr)
    print("\nfind substr \"" .. findsub .. "\" ret:")
    print(">start = " .. (i or "nil"))
    print(">end = " .. (j or "nil"))
    print(">substr = " .. (substr or "nil"))
end


function scanKeys(text)
    local keyt = {}
    local oldKey = {}
    print(text)
    for ms in text:gmatch(regexp) do
        print(ms)
        table.insert(keyt, ms)
        table.insert(oldKey, ms)
    end
    return oldKey, keyt;
end

function splitByTag(str)
    if str == nil or str == '' then
        return nil
    end
    local str_len = #str
    local cur_index = 1;
    local result = {}
    local keys = {}
    while cur_index < str_len do
        open_tag_start, open_tag_end, substr = string.find(str, "<#", cur_index, true)
        if open_tag_start == nil or open_tag_start < 0 then
            -- no data match
            result[#result + 1] = string.sub(str, cur_index)
            break
        else
            result[#result + 1] = string.sub(str, cur_index, open_tag_start - 1)
        end
        --        print("open tag>  " .. result[#result])
        close_tag_start, close_tag_end, substr = string.find(str, "#>", open_tag_end, true)
        if close_tag_start == nil or close_tag_start < 0 then
            result[#result + 1] = string.sub(str, open_tag_end + 1)
            print("There is a content no close tag #>")
            break
        end
        local sub_str = string.sub(str, open_tag_end + 1, close_tag_start - 1)
        result[#result + 1] = sub_str
        keys[sub_str] = sub_str
        --        print("close tag>  " .. result[#result])
        cur_index = close_tag_end + 1
    end
    --    print(str)
    return keys, result
end

function replace_key2value(str)
    print(str)
    keys, result = splitByTag(str)
    if (keys == nil) then
        return nil
    end

    for k, v in pairs(result) do
        print(k, v)
        if (v == nil or v == ''or keys[v]==nil) then
        else
            result[k] = keys[v].."--stub"
        end
    end
    return result
end

--t = replace_key2value([[<#Pageca060a71-1ba3-4deb-ad72-452f3aea4b7f#><#Pageca060a71-1ba3-4deb-ad72-452f3aea4b7f#><#Pageca060a71-1ba3-4deb-ad72-452f3aea4b7f#><#Pageca060a71-1ba3-4deb-ad72-452f3aea4b7f0#>","language":{"en_ca"<#Pageca060a71-1ba3-4deb-ad72-452f3aea4b7f#>]])
--t = scanKeys([[ 			</div> 			<div class="nav_item" data-url='' 	<#Pageca060a71-1ba3-4deb-ad72-452f3aea4b7f#>			data-name='&lt;#Page9966207c-7ae9-4e4f-9db8-745bc72396fb#&gt;' tabIndex="0"> 				<div class="wrap">]])

tb = replace_key2value([[{"merchandizingBannerData":{"backgroundColor":"#e4e2e2","sideMsg":{"t_id":"<#Pageca060a71-1ba3-4deb-ad72-452f3aea4b7f#>","language":{"en_ca":"%3Cp%3Emeichanidizi%3C/p%3E","fr":""},"id":"Pageca060a71-1ba3-4deb-ad72-452f3aea4b7f"},"data":[{"bannerInfo":{"t_id":"<#Page86449501-a351-4be9-b1d2-e18af5cc68d2#>","language":{"en_ca":"%3Cp%3Emessage%3C/p%3E","fr":""},"id":"Page86449501-a351-4be9-b1d2-e18af5cc68d2"}}],"autoRun":true}}]])
print(table.concat(tb))
--for k, v in pairs(t) do
--    print(k, v)
--end

for k, v in pairs(tb) do
    print(k, v)
end

local test_str = [[import Constant from "@constant/index.js";
import BaseView from "@model/core/View.js";
import Intercept from "@observer/Intercept.js";
import { reject } from "lodash-es";
export default class LadingPCView extends BaseView {

	constructor(model) {
		super(model);
		this._model = model;
		this._model._view = this;
		this._eventCenter = new LadingApi();
	}

	render() {
		this.regEvent();
		this.ladingEvent();
		this._eventCenter.getSmbBasic(this._model);
		// this._eventCenter.getLoyalty(this._model);
		// this._eventCenter.getProductCode(this._model);

	}

	regEvent() {
		let _this = this;
		$(".administrators").on("click", '.wallace .see_more_admin' , function () {
			$(".david_wallace").show()

		})
		$(".david_cross").on("click", function () {
			$(".david_wallace").hide()
		})
		$('.tier_rewards .rewards_right .rewards_button').on('click', function () {
			_this._eventCenter.joinLoyalty(_this._model);

		})
		$('.pro_progress').on('mouseover',function(e){
			if(_this._model.itdm == true){
				$('.consumption').show()
			}

		})
		$('.pro_progress').on('mouseleave ',function(e){
			$('.consumption').hide()
		})
		$('.scott_person').on('click', '.tier_view', function () {
			$('html,body').animate({ scrollTop: $(".tier_account").offset().top }, 300)
		})
		$('#uploadAvatar').on('change', function () {
			let file = $(this).get(0).files[0]
			if ("png,jpg,gif,jpeg".indexOf(file.name.substring(file.name.lastIndexOf(".") + 1)) == -1) {
				alert("Extension must be png,jpg,gif,jpeg!");
				return;
			}
			if (file.size > 1024 * 1024 * 3) {
				alert("File size must less than 3MB!")
				return;
			}
			var reader = new FileReader();
			reader.readAsDataURL(file);
			reader.onload = function (e) {
				_this._model.base64Code = reader.result
				_this._eventCenter.uploadAvatar(_this._model)
			}
		})
	}
}
class LadingApi {
	getSmbBasic(model) {
		console.log("model==============",model)
		model.getSmbBasic().then(res => {
			model.itdm = res.data.userProfileVO.isItdm
			console.log(model.itdm)
			let currencyCodes = res.data.smbCompanyVO.currencyCode
			let spendmoney = res.data.smbCompanyVO.endRevenue - res.data.smbCompanyVO.totalAmount
			let spendmoneyHtml = `Spend ${flash_fe_core_tool.$priceFormat.split3(spendmoney, currencyCodes)} more this year to unlock the Plus discount tier.`
			$('.consumption_pointer_details').html(spendmoneyHtml)
			let visit = `<a href="${res.data.smbTeleVO.smbCommunityUrl}" data-tkey="visit.the.community">Visit the Community</a>`
			$('.tier_optimize .visit_community').html(visit)
			//header image
			if (res.data.userProfileVO.filePath != null) {
				let uploadImg = `<img src="${res.data.userProfileVO.filePath}" />`
				$('.person_portrait .img').html(uploadImg)
				let html = ''
				html = `
				<div class="person_detail">
					<span class="tier_michael" data-tkey="smb.tier.name"><#${res.data.userProfileVO.firstName} ${res.data.userProfileVO.lastName}#></span>
					<span class="tier_dunder" data-tkey="smb.tier.companyName"><#${res.data.userProfileVO.companyName}#></span>
					<i class="tier_member"><i data-tkey="member.since"><#Member Since#></i> ${res.data.userProfileVO.createTime}</i>
					<i class="tier_view" data-tkey="view.account.details"><#View Account Details#></i>
				</div>
				`
				$('.scott_person').append(html)
			} else {
				let html = ''
				let f = res.data.userProfileVO.firstName
				let l = res.data.userProfileVO.lastName
				let fname = f.substr(0, 1)
				let lname = l.substr(0, 1)
				let uploadImg = `<div>${fname}${lname}</div>`
				$('.person_portrait .img').html(uploadImg)
				html = `
				<div class="person_detail">
					<span class="tier_michael">${res.data.userProfileVO.firstName} ${res.data.userProfileVO.lastName}</span>
					<span class="tier_dunder">${res.data.userProfileVO.companyName}</span>
					<i class="tier_member">Member Since ${res.data.userProfileVO.createTime}</i>
					<i class="tier_view">View Account Details</i>
				</div>
				`
				$('.scott_person').append(html)
			}

			// tierPicture
			let gradeImg = `<img src="${res.data.smbCompanyVO.tierPicture}">`
			$('.administrators .administrators_img').html(gradeImg)

			//tele
			let teleHtml = ''
			if(res.data.smbTeleVO.defaultTeleAccount == false){
				teleHtml += `
					<div class="member_help">
						<p class="member_help_title"><span data-tkey="Need.help"><#Need help#>?</span> <i data-tkey="Contact.your.Lenovo.Representative"><#Contact your Lenovo Representative#>:<i></p>
						<div class="member_help_container">
							<span class="container_img">
								<img src="//p1-ofp.lenovouat.com/fes/cms/2021/04/27/qq2e4qbsqh1ekdbd6xma9himsqckd6517829.svg" alt="">
							</span>
							<div class="container_detail">
								<p data-tkey="Dwight.Shrute"><#${res.data.smbTeleVO.teleAccount[0].firstName} ${res.data.smbTeleVO.teleAccount[0].lastName}#></p>
								<p class="tele_email">${res.data.smbTeleVO.teleAccount[0].email}</p>
								<p class="tete_phone_number">${res.data.smbTeleVO.teleAccount[0].phone}</p>
							</div>
						</div>
						<p>or <a href="${res.data.smbTeleVO.smbCommunityUrl}" class="tele_visit" data-tkey="visit.our.Community"><#visit our Community#></a> <i data-tkey="to.connect.with.other.PRO.members">to connect with other PRO members</i>. </p>
					</div>
				`
			}else{
				teleHtml += `
					<div class="itdm_help">
						<div class="help_img">
							<img src="http://p2-ofp.lenovouat.cn/fes/cms/2021/06/29/bzpbnl2jretasbghk1ry322bjb6l3s762295.jpg
							"
								alt="">
						</div>
						<div class="need_help">
							<span data-tkey="Need.help"><#Need help#>?</span>
							<span class="contans"><i data-tkey="Call.our.Small.Business.specialists.at"><#Call our Small Business specialists at#></i>
								<a href="#"> ${res.data.smbTeleVO.teleAccount[0].phone} </a> <i data-tkey="or"><#or#></i> <a href="${res.data.smbTeleVO.smbCommunityUrl}" data-tkey="visit.our.Community"><#visit our Community#></a>
								<i data-tkey="to.connect.with.other.SMB.professionals"><#to connect with other SMB professionals#></i>. </span>
						</div>
					</div>
				`
			}
			$('.tier_help').html(teleHtml)

			// bar image
			let tiergrade = res.data.smbCompanyVO.tierGrade
			let tierPicture = `<img src="${res.data.smbCompanyVO.tierPicture}"/>`
			if (res.data.smbCompanyVO.tierGrade == 1) {
				$('.ordinary').html(tierPicture)
			} else if (res.data.smbCompanyVO.tierGrade == 2) {
				$('.senior').html(tierPicture)
			} else if (res.data.smbCompanyVO.tierGrade == 3) {
				$('.honorable').html(tierPicture)
			}
			// debugger
			let itdmHtml = ''
			if (res.data.userProfileVO.isItdm == true) {
				let currentYearAmount =	flash_fe_core_tool.$priceFormat.split3(res.data.smbCompanyVO.currentYearAmount, currencyCodes)
				itdmHtml = `
					<span class="admin_menber" data-tkey="LenovoPRO.Pro.Tier.Member"><#LenovoPRO Pro Tier Member#></span>
					<div class="admin_isItadm" data-tkey="Annual.Spend">
						<#Annual Spend:#> ${currentYearAmount}
					</div>`
				$('.admin_detail').html(itdmHtml)
				if (tiergrade == 1) {
					if (res.data.smbCompanyVO.percentCurrent >= 50) {

						let widths = 2 * ($('.progress').width()) * (res.data.smbCompanyVO.percentCurrent - 50) / 100 + 'px'
						$('.consumption').css({"left":$('.pro_progress').width()+$('.progress').width()* (res.data.smbCompanyVO.percentCurrent - 50) / 100 + 'px'})
						$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
						if (res.data.smbCompanyVO.percentCurrent == 100) {
							$('.bar2 span').css({
								'width': '100%',
								'background': res.data.smbCompanyVO.tierColor,
								"border-top-right-radius": '5px',
								"border-bottom-right-radius": '5px',
							})
						} else {
							$('.bar2 span').css({ 'width': widths, 'background': res.data.smbCompanyVO.tierColor })
						}
					} else {
						let barWidth = 2 * ($('.progress').width()) * res.data.smbCompanyVO.percentCurrent / 100 + 'px'
						$('.bar1 span').css({ 'width': barWidth, 'background': res.data.smbCompanyVO.tierColor })
					}
				}
				if (tiergrade == 2) {
					$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar2 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
					if (res.data.smbCompanyVO.percentCurrent >= 50) {
						$('.consumption').css({"left":2*$('.pro_progress').width()+$('.progress').width()* (res.data.smbCompanyVO.percentCurrent - 50) / 100 + 'px'})
						let widths = 2 * ($('.progress').width()) * (res.data.smbCompanyVO.percentCurrent - 50) / 100 + 'px'

						$('.bar3 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
						if (res.data.smbCompanyVO.percentCurrent == 100) {
							$('.bar4 span').css({
								'width': '100%',
								'background': res.data.smbCompanyVO.tierColor,
								"border-top-right-radius": '5px',
								"border-bottom-right-radius": '5px',
							})
						} else {
							$('.bar4 span').css({ 'width': widths, 'background': res.data.smbCompanyVO.tierColor })
						}
					} else {
						let barWidth = 2 * ($('.progress').width()) * res.data.smbCompanyVO.percentCurrent / 100 + 'px'
						$('.bar3 span').css({ 'width': barWidth, 'background': res.data.smbCompanyVO.tierColor })
					}
				}

				if(tiergrade == 3){
					$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar2 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
					$('.bar3 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar4 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
				}

			}else{
				let itdmListLen= res.data.smbItdmListVO.itdmList.length
				itdmHtml = `
				<span class="admin_menber" data-tkey="LenovoPRO.Pro.Tier.Member"><#LenovoPRO Pro Tier Member#></span>
				<div class="admin_notitdm">
					<span class="admin" data-tkey="Your.Administrators"><#Your Administrators:#></span>
					<span class="wallace" data-tkey="David.Wallace"><#${res.data.smbItdmListVO.itdmList[0].name}#> <a class="see_more_admin">+${itdmListLen}more</a>
					<i><a href="${res.data.smbItdmListVO.itdmList[0].email}">${res.data.smbItdmListVO.itdmList[0].email}</a></i>
					</span>
				</div>`
				$('.admin_detail').html(itdmHtml)
				if(tiergrade == 2){
					$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar2 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
				}
				if(tiergrade == 3){
					$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar2 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
					$('.bar3 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar4 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
				}
			}

			// bar details
			// let arr = res.data.smbCompanyVO.companyTier;
			// $('.garde_detail').html('');
			// arr.forEach((item,index) => {
			// 	let detailsDom = `<div class="details">${item.description}</div>`;
			// 	$('.garde_detail').append(detailsDom);

			// });



			// email
			let itdmemail = res.data.smbItdmListVO.itdmList
			let emailHtml = ''
			itdmemail.forEach((item, index) => {
				emailHtml += `
					<li>
						<span>${(item.name==null)?'':item.name}</span>
						<i>${(item.email==null)?'':item.email}</i>
						<i>${(item.phoneNumber)==null?'':item.phoneNumber}</i>
					</li>
				`
			});
			$('.franklin-reallylongn ul').html(emailHtml)

		}).catch(err => {
			window.alert(err.msg)
		})
	}

	getLoyalty(model) {
		model.getLoyalty().then(res => {
			let loyaltyList = res.data
			let objLoyaltylist = loyaltyList.loyaltyUserInfoVO
			if (loyaltyList.storeToggle == true && loyaltyList.userToggle == true) {
				$('.tier_rewards .noloyalty_rewards').hide()
				let haveLoyalty = `
				<div class="loyalty_rewards">
					<div class="rewards_left">
						<span class="mylenovo_rewards">
							<img src="https://p2-ofp.static.pub/fes/cms/2021/06/05/i0xb3cnq76vmnkqcfsdugoqa78jz80947591.svg"
								alt="">
						</span>
						<span class="my_rewards">
							<p data-tkey="My.Rewards"><#My Rewards#></p>
							<i><#${objLoyaltylist.rewardsFormattedValue}#></i>
						</span>
						<span class="points">
							<p data-tkey="Available.Points"><#Available Points#></p>
							<i><#${objLoyaltylist.redeemablePointsFormat}#></i>
						</span>
					</div>
					<div class="rewards_right">
						<div class="right_since">
							<i data-tkey="rewards.member.since"><#Rewards Member Since#></i>  <i>${objLoyaltylist.joinLoyaltyYear}</i>
						</div>
						<div class="right_button">
							<a target="_blank" href="https://account.gl.lenovouat.com/us/smb/en/account/rewards/index.html" data-tkey="See.My.Rewards"><#See My Rewards#></a>
						</div>
					</div>
				</div>
				`
				$('.tier_rewards').html(haveLoyalty)
			}
			else {
				$('.tier_rewards .noloyalty_rewards').show()
			}
		})
	}

	joinLoyalty(model) {
		model.joinLoyalty().then((res) => {
			if (res.status == 200) {
				window.alert('Operation successful')
				location.reload();
			}
		})
	}

	uploadAvatar(model) {
		model.uploadAvatar(model).then(x => {
			if(x.status == 200){
				let uploadImg = `<img src="${x.data}" />`
				$('.person_portrait .img').html(uploadImg)
			}
		})
	}

	getProductCode(model) {
		model.getProductCode(model).then(res => {
			let list= res.data.recommList
			model.productNumbers = list.toString()
			// this.getProduct(model);
			flash_fe_core_tool.$productPrice.ppByPns(model.productNumbers, flash_fe_core_tool.$CONSTANT.PDODUCT_LIST_TYPE.RECOMMENDATON).then(res=>{
				console.log("373===============",res)
				if(res && res.validProducts.length>0){
					let validProducts = res.validProducts
					let productlist = ''
					validProducts.forEach((item,index)=>{
						let imgURL = item.$img && item.$img.customThumbnail
						productlist += `
								<li>
									<img src="${(imgURL && imgURL.imageAddress)? imgURL.imageAddress:""}" alt="${item.summary}">
									<span class="item_title" data-tkey="smb.product.name"><#${item.summary}#></span>
									<span class="item_price">${item.priceInfo.$price.price}</span>
								</li>
								`
						$('.products_item ul').html(productlist)
					})
				}
			})
		}).catch(err => {
			reject(err)
		})
	}
}import Constant from "@constant/index.js";
import BaseView from "@model/core/View.js";
import Intercept from "@observer/Intercept.js";
import { reject } from "lodash-es";
export default class LadingPCView extends BaseView {

	constructor(model) {
		super(model);
		this._model = model;
		this._model._view = this;
		this._eventCenter = new LadingApi();
	}

	render() {
		this.regEvent();
		this.ladingEvent();
		this._eventCenter.getSmbBasic(this._model);
		// this._eventCenter.getLoyalty(this._model);
		// this._eventCenter.getProductCode(this._model);

	}

	regEvent() {
		let _this = this;
		$(".administrators").on("click", '.wallace .see_more_admin' , function () {
			$(".david_wallace").show()

		})
		$(".david_cross").on("click", function () {
			$(".david_wallace").hide()
		})
		$('.tier_rewards .rewards_right .rewards_button').on('click', function () {
			_this._eventCenter.joinLoyalty(_this._model);

		})
		$('.pro_progress').on('mouseover',function(e){
			if(_this._model.itdm == true){
				$('.consumption').show()
			}

		})
		$('.pro_progress').on('mouseleave ',function(e){
			$('.consumption').hide()
		})
		$('.scott_person').on('click', '.tier_view', function () {
			$('html,body').animate({ scrollTop: $(".tier_account").offset().top }, 300)
		})
		$('#uploadAvatar').on('change', function () {
			let file = $(this).get(0).files[0]
			if ("png,jpg,gif,jpeg".indexOf(file.name.substring(file.name.lastIndexOf(".") + 1)) == -1) {
				alert("Extension must be png,jpg,gif,jpeg!");
				return;
			}
			if (file.size > 1024 * 1024 * 3) {
				alert("File size must less than 3MB!")
				return;
			}
			var reader = new FileReader();
			reader.readAsDataURL(file);
			reader.onload = function (e) {
				_this._model.base64Code = reader.result
				_this._eventCenter.uploadAvatar(_this._model)
			}
		})
	}
}
class LadingApi {
	getSmbBasic(model) {
		console.log("model==============",model)
		model.getSmbBasic().then(res => {
			model.itdm = res.data.userProfileVO.isItdm
			console.log(model.itdm)
			let currencyCodes = res.data.smbCompanyVO.currencyCode
			let spendmoney = res.data.smbCompanyVO.endRevenue - res.data.smbCompanyVO.totalAmount
			let spendmoneyHtml = `Spend ${flash_fe_core_tool.$priceFormat.split3(spendmoney, currencyCodes)} more this year to unlock the Plus discount tier.`
			$('.consumption_pointer_details').html(spendmoneyHtml)
			let visit = `<a href="${res.data.smbTeleVO.smbCommunityUrl}" data-tkey="visit.the.community">Visit the Community</a>`
			$('.tier_optimize .visit_community').html(visit)
			//header image
			if (res.data.userProfileVO.filePath != null) {
				let uploadImg = `<img src="${res.data.userProfileVO.filePath}" />`
				$('.person_portrait .img').html(uploadImg)
				let html = ''
				html = `
				<div class="person_detail">
					<span class="tier_michael" data-tkey="smb.tier.name"><#${res.data.userProfileVO.firstName} ${res.data.userProfileVO.lastName}#></span>
					<span class="tier_dunder" data-tkey="smb.tier.companyName"><#${res.data.userProfileVO.companyName}#></span>
					<i class="tier_member"><i data-tkey="member.since"><#Member Since#></i> ${res.data.userProfileVO.createTime}</i>
					<i class="tier_view" data-tkey="view.account.details"><#View Account Details#></i>
				</div>
				`
				$('.scott_person').append(html)
			} else {
				let html = ''
				let f = res.data.userProfileVO.firstName
				let l = res.data.userProfileVO.lastName
				let fname = f.substr(0, 1)
				let lname = l.substr(0, 1)
				let uploadImg = `<div>${fname}${lname}</div>`
				$('.person_portrait .img').html(uploadImg)
				html = `
				<div class="person_detail">
					<span class="tier_michael">${res.data.userProfileVO.firstName} ${res.data.userProfileVO.lastName}</span>
					<span class="tier_dunder">${res.data.userProfileVO.companyName}</span>
					<i class="tier_member">Member Since ${res.data.userProfileVO.createTime}</i>
					<i class="tier_view">View Account Details</i>
				</div>
				`
				$('.scott_person').append(html)
			}

			// tierPicture
			let gradeImg = `<img src="${res.data.smbCompanyVO.tierPicture}">`
			$('.administrators .administrators_img').html(gradeImg)

			//tele
			let teleHtml = ''
			if(res.data.smbTeleVO.defaultTeleAccount == false){
				teleHtml += `
					<div class="member_help">
						<p class="member_help_title"><span data-tkey="Need.help"><#Need help#>?</span> <i data-tkey="Contact.your.Lenovo.Representative"><#Contact your Lenovo Representative#>:<i></p>
						<div class="member_help_container">
							<span class="container_img">
								<img src="//p1-ofp.lenovouat.com/fes/cms/2021/04/27/qq2e4qbsqh1ekdbd6xma9himsqckd6517829.svg" alt="">
							</span>
							<div class="container_detail">
								<p data-tkey="Dwight.Shrute"><#${res.data.smbTeleVO.teleAccount[0].firstName} ${res.data.smbTeleVO.teleAccount[0].lastName}#></p>
								<p class="tele_email">${res.data.smbTeleVO.teleAccount[0].email}</p>
								<p class="tete_phone_number">${res.data.smbTeleVO.teleAccount[0].phone}</p>
							</div>
						</div>
						<p>or <a href="${res.data.smbTeleVO.smbCommunityUrl}" class="tele_visit" data-tkey="visit.our.Community"><#visit our Community#></a> <i data-tkey="to.connect.with.other.PRO.members">to connect with other PRO members</i>. </p>
					</div>
				`
			}else{
				teleHtml += `
					<div class="itdm_help">
						<div class="help_img">
							<img src="http://p2-ofp.lenovouat.cn/fes/cms/2021/06/29/bzpbnl2jretasbghk1ry322bjb6l3s762295.jpg
							"
								alt="">
						</div>
						<div class="need_help">
							<span data-tkey="Need.help"><#Need help#>?</span>
							<span class="contans"><i data-tkey="Call.our.Small.Business.specialists.at"><#Call our Small Business specialists at#></i>
								<a href="#"> ${res.data.smbTeleVO.teleAccount[0].phone} </a> <i data-tkey="or"><#or#></i> <a href="${res.data.smbTeleVO.smbCommunityUrl}" data-tkey="visit.our.Community"><#visit our Community#></a>
								<i data-tkey="to.connect.with.other.SMB.professionals"><#to connect with other SMB professionals#></i>. </span>
						</div>
					</div>
				`
			}
			$('.tier_help').html(teleHtml)

			// bar image
			let tiergrade = res.data.smbCompanyVO.tierGrade
			let tierPicture = `<img src="${res.data.smbCompanyVO.tierPicture}"/>`
			if (res.data.smbCompanyVO.tierGrade == 1) {
				$('.ordinary').html(tierPicture)
			} else if (res.data.smbCompanyVO.tierGrade == 2) {
				$('.senior').html(tierPicture)
			} else if (res.data.smbCompanyVO.tierGrade == 3) {
				$('.honorable').html(tierPicture)
			}
			// debugger
			let itdmHtml = ''
			if (res.data.userProfileVO.isItdm == true) {
				let currentYearAmount =	flash_fe_core_tool.$priceFormat.split3(res.data.smbCompanyVO.currentYearAmount, currencyCodes)
				itdmHtml = `
					<span class="admin_menber" data-tkey="LenovoPRO.Pro.Tier.Member"><#LenovoPRO Pro Tier Member#></span>
					<div class="admin_isItadm" data-tkey="Annual.Spend">
						<#Annual Spend:#> ${currentYearAmount}
					</div>`
				$('.admin_detail').html(itdmHtml)
				if (tiergrade == 1) {
					if (res.data.smbCompanyVO.percentCurrent >= 50) {

						let widths = 2 * ($('.progress').width()) * (res.data.smbCompanyVO.percentCurrent - 50) / 100 + 'px'
						$('.consumption').css({"left":$('.pro_progress').width()+$('.progress').width()* (res.data.smbCompanyVO.percentCurrent - 50) / 100 + 'px'})
						$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
						if (res.data.smbCompanyVO.percentCurrent == 100) {
							$('.bar2 span').css({
								'width': '100%',
								'background': res.data.smbCompanyVO.tierColor,
								"border-top-right-radius": '5px',
								"border-bottom-right-radius": '5px',
							})
						} else {
							$('.bar2 span').css({ 'width': widths, 'background': res.data.smbCompanyVO.tierColor })
						}
					} else {
						let barWidth = 2 * ($('.progress').width()) * res.data.smbCompanyVO.percentCurrent / 100 + 'px'
						$('.bar1 span').css({ 'width': barWidth, 'background': res.data.smbCompanyVO.tierColor })
					}
				}
				if (tiergrade == 2) {
					$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar2 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
					if (res.data.smbCompanyVO.percentCurrent >= 50) {
						$('.consumption').css({"left":2*$('.pro_progress').width()+$('.progress').width()* (res.data.smbCompanyVO.percentCurrent - 50) / 100 + 'px'})
						let widths = 2 * ($('.progress').width()) * (res.data.smbCompanyVO.percentCurrent - 50) / 100 + 'px'

						$('.bar3 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
						if (res.data.smbCompanyVO.percentCurrent == 100) {
							$('.bar4 span').css({
								'width': '100%',
								'background': res.data.smbCompanyVO.tierColor,
								"border-top-right-radius": '5px',
								"border-bottom-right-radius": '5px',
							})
						} else {
							$('.bar4 span').css({ 'width': widths, 'background': res.data.smbCompanyVO.tierColor })
						}
					} else {
						let barWidth = 2 * ($('.progress').width()) * res.data.smbCompanyVO.percentCurrent / 100 + 'px'
						$('.bar3 span').css({ 'width': barWidth, 'background': res.data.smbCompanyVO.tierColor })
					}
				}

				if(tiergrade == 3){
					$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar2 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
					$('.bar3 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar4 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
				}

			}else{
				let itdmListLen= res.data.smbItdmListVO.itdmList.length
				itdmHtml = `
				<span class="admin_menber" data-tkey="LenovoPRO.Pro.Tier.Member"><#LenovoPRO Pro Tier Member#></span>
				<div class="admin_notitdm">
					<span class="admin" data-tkey="Your.Administrators"><#Your Administrators:#></span>
					<span class="wallace" data-tkey="David.Wallace"><#${res.data.smbItdmListVO.itdmList[0].name}#> <a class="see_more_admin">+${itdmListLen}more</a>
					<i><a href="${res.data.smbItdmListVO.itdmList[0].email}">${res.data.smbItdmListVO.itdmList[0].email}</a></i>
					</span>
				</div>`
				$('.admin_detail').html(itdmHtml)
				if(tiergrade == 2){
					$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar2 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
				}
				if(tiergrade == 3){
					$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar2 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
					$('.bar3 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar4 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
				}
			}

			// bar details
			// let arr = res.data.smbCompanyVO.companyTier;
			// $('.garde_detail').html('');
			// arr.forEach((item,index) => {
			// 	let detailsDom = `<div class="details">${item.description}</div>`;
			// 	$('.garde_detail').append(detailsDom);

			// });



			// email
			let itdmemail = res.data.smbItdmListVO.itdmList
			let emailHtml = ''
			itdmemail.forEach((item, index) => {
				emailHtml += `
					<li>
						<span>${(item.name==null)?'':item.name}</span>
						<i>${(item.email==null)?'':item.email}</i>
						<i>${(item.phoneNumber)==null?'':item.phoneNumber}</i>
					</li>
				`
			});
			$('.franklin-reallylongn ul').html(emailHtml)

		}).catch(err => {
			window.alert(err.msg)
		})
	}

	getLoyalty(model) {
		model.getLoyalty().then(res => {
			let loyaltyList = res.data
			let objLoyaltylist = loyaltyList.loyaltyUserInfoVO
			if (loyaltyList.storeToggle == true && loyaltyList.userToggle == true) {
				$('.tier_rewards .noloyalty_rewards').hide()
				let haveLoyalty = `
				<div class="loyalty_rewards">
					<div class="rewards_left">
						<span class="mylenovo_rewards">
							<img src="https://p2-ofp.static.pub/fes/cms/2021/06/05/i0xb3cnq76vmnkqcfsdugoqa78jz80947591.svg"
								alt="">
						</span>
						<span class="my_rewards">
							<p data-tkey="My.Rewards"><#My Rewards#></p>
							<i><#${objLoyaltylist.rewardsFormattedValue}#></i>
						</span>
						<span class="points">
							<p data-tkey="Available.Points"><#Available Points#></p>
							<i><#${objLoyaltylist.redeemablePointsFormat}#></i>
						</span>
					</div>
					<div class="rewards_right">
						<div class="right_since">
							<i data-tkey="rewards.member.since"><#Rewards Member Since#></i>  <i>${objLoyaltylist.joinLoyaltyYear}</i>
						</div>
						<div class="right_button">
							<a target="_blank" href="https://account.gl.lenovouat.com/us/smb/en/account/rewards/index.html" data-tkey="See.My.Rewards"><#See My Rewards#></a>
						</div>
					</div>
				</div>
				`
				$('.tier_rewards').html(haveLoyalty)
			}
			else {
				$('.tier_rewards .noloyalty_rewards').show()
			}
		})
	}

	joinLoyalty(model) {
		model.joinLoyalty().then((res) => {
			if (res.status == 200) {
				window.alert('Operation successful')
				location.reload();
			}
		})
	}

	uploadAvatar(model) {
		model.uploadAvatar(model).then(x => {
			if(x.status == 200){
				let uploadImg = `<img src="${x.data}" />`
				$('.person_portrait .img').html(uploadImg)
			}
		})
	}

	getProductCode(model) {
		model.getProductCode(model).then(res => {
			let list= res.data.recommList
			model.productNumbers = list.toString()
			// this.getProduct(model);
			flash_fe_core_tool.$productPrice.ppByPns(model.productNumbers, flash_fe_core_tool.$CONSTANT.PDODUCT_LIST_TYPE.RECOMMENDATON).then(res=>{
				console.log("373===============",res)
				if(res && res.validProducts.length>0){
					let validProducts = res.validProducts
					let productlist = ''
					validProducts.forEach((item,index)=>{
						let imgURL = item.$img && item.$img.customThumbnail
						productlist += `
								<li>
									<img src="${(imgURL && imgURL.imageAddress)? imgURL.imageAddress:""}" alt="${item.summary}">
									<span class="item_title" data-tkey="smb.product.name"><#${item.summary}#></span>
									<span class="item_price">${item.priceInfo.$price.price}</span>
								</li>
								`
						$('.products_item ul').html(productlist)
					})
				}
			})
		}).catch(err => {
			reject(err)
		})
	}
}import Constant from "@constant/index.js";
import BaseView from "@model/core/View.js";
import Intercept from "@observer/Intercept.js";
import { reject } from "lodash-es";
export default class LadingPCView extends BaseView {

	constructor(model) {
		super(model);
		this._model = model;
		this._model._view = this;
		this._eventCenter = new LadingApi();
	}

	render() {
		this.regEvent();
		this.ladingEvent();
		this._eventCenter.getSmbBasic(this._model);
		// this._eventCenter.getLoyalty(this._model);
		// this._eventCenter.getProductCode(this._model);

	}

	regEvent() {
		let _this = this;
		$(".administrators").on("click", '.wallace .see_more_admin' , function () {
			$(".david_wallace").show()

		})
		$(".david_cross").on("click", function () {
			$(".david_wallace").hide()
		})
		$('.tier_rewards .rewards_right .rewards_button').on('click', function () {
			_this._eventCenter.joinLoyalty(_this._model);

		})
		$('.pro_progress').on('mouseover',function(e){
			if(_this._model.itdm == true){
				$('.consumption').show()
			}

		})
		$('.pro_progress').on('mouseleave ',function(e){
			$('.consumption').hide()
		})
		$('.scott_person').on('click', '.tier_view', function () {
			$('html,body').animate({ scrollTop: $(".tier_account").offset().top }, 300)
		})
		$('#uploadAvatar').on('change', function () {
			let file = $(this).get(0).files[0]
			if ("png,jpg,gif,jpeg".indexOf(file.name.substring(file.name.lastIndexOf(".") + 1)) == -1) {
				alert("Extension must be png,jpg,gif,jpeg!");
				return;
			}
			if (file.size > 1024 * 1024 * 3) {
				alert("File size must less than 3MB!")
				return;
			}
			var reader = new FileReader();
			reader.readAsDataURL(file);
			reader.onload = function (e) {
				_this._model.base64Code = reader.result
				_this._eventCenter.uploadAvatar(_this._model)
			}
		})
	}
}
class LadingApi {
	getSmbBasic(model) {
		console.log("model==============",model)
		model.getSmbBasic().then(res => {
			model.itdm = res.data.userProfileVO.isItdm
			console.log(model.itdm)
			let currencyCodes = res.data.smbCompanyVO.currencyCode
			let spendmoney = res.data.smbCompanyVO.endRevenue - res.data.smbCompanyVO.totalAmount
			let spendmoneyHtml = `Spend ${flash_fe_core_tool.$priceFormat.split3(spendmoney, currencyCodes)} more this year to unlock the Plus discount tier.`
			$('.consumption_pointer_details').html(spendmoneyHtml)
			let visit = `<a href="${res.data.smbTeleVO.smbCommunityUrl}" data-tkey="visit.the.community">Visit the Community</a>`
			$('.tier_optimize .visit_community').html(visit)
			//header image
			if (res.data.userProfileVO.filePath != null) {
				let uploadImg = `<img src="${res.data.userProfileVO.filePath}" />`
				$('.person_portrait .img').html(uploadImg)
				let html = ''
				html = `
				<div class="person_detail">
					<span class="tier_michael" data-tkey="smb.tier.name"><#${res.data.userProfileVO.firstName} ${res.data.userProfileVO.lastName}#></span>
					<span class="tier_dunder" data-tkey="smb.tier.companyName"><#${res.data.userProfileVO.companyName}#></span>
					<i class="tier_member"><i data-tkey="member.since"><#Member Since#></i> ${res.data.userProfileVO.createTime}</i>
					<i class="tier_view" data-tkey="view.account.details"><#View Account Details#></i>
				</div>
				`
				$('.scott_person').append(html)
			} else {
				let html = ''
				let f = res.data.userProfileVO.firstName
				let l = res.data.userProfileVO.lastName
				let fname = f.substr(0, 1)
				let lname = l.substr(0, 1)
				let uploadImg = `<div>${fname}${lname}</div>`
				$('.person_portrait .img').html(uploadImg)
				html = `
				<div class="person_detail">
					<span class="tier_michael">${res.data.userProfileVO.firstName} ${res.data.userProfileVO.lastName}</span>
					<span class="tier_dunder">${res.data.userProfileVO.companyName}</span>
					<i class="tier_member">Member Since ${res.data.userProfileVO.createTime}</i>
					<i class="tier_view">View Account Details</i>
				</div>
				`
				$('.scott_person').append(html)
			}

			// tierPicture
			let gradeImg = `<img src="${res.data.smbCompanyVO.tierPicture}">`
			$('.administrators .administrators_img').html(gradeImg)

			//tele
			let teleHtml = ''
			if(res.data.smbTeleVO.defaultTeleAccount == false){
				teleHtml += `
					<div class="member_help">
						<p class="member_help_title"><span data-tkey="Need.help"><#Need help#>?</span> <i data-tkey="Contact.your.Lenovo.Representative"><#Contact your Lenovo Representative#>:<i></p>
						<div class="member_help_container">
							<span class="container_img">
								<img src="//p1-ofp.lenovouat.com/fes/cms/2021/04/27/qq2e4qbsqh1ekdbd6xma9himsqckd6517829.svg" alt="">
							</span>
							<div class="container_detail">
								<p data-tkey="Dwight.Shrute"><#${res.data.smbTeleVO.teleAccount[0].firstName} ${res.data.smbTeleVO.teleAccount[0].lastName}#></p>
								<p class="tele_email">${res.data.smbTeleVO.teleAccount[0].email}</p>
								<p class="tete_phone_number">${res.data.smbTeleVO.teleAccount[0].phone}</p>
							</div>
						</div>
						<p>or <a href="${res.data.smbTeleVO.smbCommunityUrl}" class="tele_visit" data-tkey="visit.our.Community"><#visit our Community#></a> <i data-tkey="to.connect.with.other.PRO.members">to connect with other PRO members</i>. </p>
					</div>
				`
			}else{
				teleHtml += `
					<div class="itdm_help">
						<div class="help_img">
							<img src="http://p2-ofp.lenovouat.cn/fes/cms/2021/06/29/bzpbnl2jretasbghk1ry322bjb6l3s762295.jpg
							"
								alt="">
						</div>
						<div class="need_help">
							<span data-tkey="Need.help"><#Need help#>?</span>
							<span class="contans"><i data-tkey="Call.our.Small.Business.specialists.at"><#Call our Small Business specialists at#></i>
								<a href="#"> ${res.data.smbTeleVO.teleAccount[0].phone} </a> <i data-tkey="or"><#or#></i> <a href="${res.data.smbTeleVO.smbCommunityUrl}" data-tkey="visit.our.Community"><#visit our Community#></a>
								<i data-tkey="to.connect.with.other.SMB.professionals"><#to connect with other SMB professionals#></i>. </span>
						</div>
					</div>
				`
			}
			$('.tier_help').html(teleHtml)

			// bar image
			let tiergrade = res.data.smbCompanyVO.tierGrade
			let tierPicture = `<img src="${res.data.smbCompanyVO.tierPicture}"/>`
			if (res.data.smbCompanyVO.tierGrade == 1) {
				$('.ordinary').html(tierPicture)
			} else if (res.data.smbCompanyVO.tierGrade == 2) {
				$('.senior').html(tierPicture)
			} else if (res.data.smbCompanyVO.tierGrade == 3) {
				$('.honorable').html(tierPicture)
			}
			// debugger
			let itdmHtml = ''
			if (res.data.userProfileVO.isItdm == true) {
				let currentYearAmount =	flash_fe_core_tool.$priceFormat.split3(res.data.smbCompanyVO.currentYearAmount, currencyCodes)
				itdmHtml = `
					<span class="admin_menber" data-tkey="LenovoPRO.Pro.Tier.Member"><#LenovoPRO Pro Tier Member#></span>
					<div class="admin_isItadm" data-tkey="Annual.Spend">
						<#Annual Spend:#> ${currentYearAmount}
					</div>`
				$('.admin_detail').html(itdmHtml)
				if (tiergrade == 1) {
					if (res.data.smbCompanyVO.percentCurrent >= 50) {

						let widths = 2 * ($('.progress').width()) * (res.data.smbCompanyVO.percentCurrent - 50) / 100 + 'px'
						$('.consumption').css({"left":$('.pro_progress').width()+$('.progress').width()* (res.data.smbCompanyVO.percentCurrent - 50) / 100 + 'px'})
						$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
						if (res.data.smbCompanyVO.percentCurrent == 100) {
							$('.bar2 span').css({
								'width': '100%',
								'background': res.data.smbCompanyVO.tierColor,
								"border-top-right-radius": '5px',
								"border-bottom-right-radius": '5px',
							})
						} else {
							$('.bar2 span').css({ 'width': widths, 'background': res.data.smbCompanyVO.tierColor })
						}
					} else {
						let barWidth = 2 * ($('.progress').width()) * res.data.smbCompanyVO.percentCurrent / 100 + 'px'
						$('.bar1 span').css({ 'width': barWidth, 'background': res.data.smbCompanyVO.tierColor })
					}
				}
				if (tiergrade == 2) {
					$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar2 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
					if (res.data.smbCompanyVO.percentCurrent >= 50) {
						$('.consumption').css({"left":2*$('.pro_progress').width()+$('.progress').width()* (res.data.smbCompanyVO.percentCurrent - 50) / 100 + 'px'})
						let widths = 2 * ($('.progress').width()) * (res.data.smbCompanyVO.percentCurrent - 50) / 100 + 'px'

						$('.bar3 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
						if (res.data.smbCompanyVO.percentCurrent == 100) {
							$('.bar4 span').css({
								'width': '100%',
								'background': res.data.smbCompanyVO.tierColor,
								"border-top-right-radius": '5px',
								"border-bottom-right-radius": '5px',
							})
						} else {
							$('.bar4 span').css({ 'width': widths, 'background': res.data.smbCompanyVO.tierColor })
						}
					} else {
						let barWidth = 2 * ($('.progress').width()) * res.data.smbCompanyVO.percentCurrent / 100 + 'px'
						$('.bar3 span').css({ 'width': barWidth, 'background': res.data.smbCompanyVO.tierColor })
					}
				}

				if(tiergrade == 3){
					$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar2 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
					$('.bar3 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar4 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
				}

			}else{
				let itdmListLen= res.data.smbItdmListVO.itdmList.length
				itdmHtml = `
				<span class="admin_menber" data-tkey="LenovoPRO.Pro.Tier.Member"><#LenovoPRO Pro Tier Member#></span>
				<div class="admin_notitdm">
					<span class="admin" data-tkey="Your.Administrators"><#Your Administrators:#></span>
					<span class="wallace" data-tkey="David.Wallace"><#${res.data.smbItdmListVO.itdmList[0].name}#> <a class="see_more_admin">+${itdmListLen}more</a>
					<i><a href="${res.data.smbItdmListVO.itdmList[0].email}">${res.data.smbItdmListVO.itdmList[0].email}</a></i>
					</span>
				</div>`
				$('.admin_detail').html(itdmHtml)
				if(tiergrade == 2){
					$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar2 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
				}
				if(tiergrade == 3){
					$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar2 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
					$('.bar3 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar4 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
				}
			}

			// bar details
			// let arr = res.data.smbCompanyVO.companyTier;
			// $('.garde_detail').html('');
			// arr.forEach((item,index) => {
			// 	let detailsDom = `<div class="details">${item.description}</div>`;
			// 	$('.garde_detail').append(detailsDom);

			// });



			// email
			let itdmemail = res.data.smbItdmListVO.itdmList
			let emailHtml = ''
			itdmemail.forEach((item, index) => {
				emailHtml += `
					<li>
						<span>${(item.name==null)?'':item.name}</span>
						<i>${(item.email==null)?'':item.email}</i>
						<i>${(item.phoneNumber)==null?'':item.phoneNumber}</i>
					</li>
				`
			});
			$('.franklin-reallylongn ul').html(emailHtml)

		}).catch(err => {
			window.alert(err.msg)
		})
	}

	getLoyalty(model) {
		model.getLoyalty().then(res => {
			let loyaltyList = res.data
			let objLoyaltylist = loyaltyList.loyaltyUserInfoVO
			if (loyaltyList.storeToggle == true && loyaltyList.userToggle == true) {
				$('.tier_rewards .noloyalty_rewards').hide()
				let haveLoyalty = `
				<div class="loyalty_rewards">
					<div class="rewards_left">
						<span class="mylenovo_rewards">
							<img src="https://p2-ofp.static.pub/fes/cms/2021/06/05/i0xb3cnq76vmnkqcfsdugoqa78jz80947591.svg"
								alt="">
						</span>
						<span class="my_rewards">
							<p data-tkey="My.Rewards"><#My Rewards#></p>
							<i><#${objLoyaltylist.rewardsFormattedValue}#></i>
						</span>
						<span class="points">
							<p data-tkey="Available.Points"><#Available Points#></p>
							<i><#${objLoyaltylist.redeemablePointsFormat}#></i>
						</span>
					</div>
					<div class="rewards_right">
						<div class="right_since">
							<i data-tkey="rewards.member.since"><#Rewards Member Since#></i>  <i>${objLoyaltylist.joinLoyaltyYear}</i>
						</div>
						<div class="right_button">
							<a target="_blank" href="https://account.gl.lenovouat.com/us/smb/en/account/rewards/index.html" data-tkey="See.My.Rewards"><#See My Rewards#></a>
						</div>
					</div>
				</div>
				`
				$('.tier_rewards').html(haveLoyalty)
			}
			else {
				$('.tier_rewards .noloyalty_rewards').show()
			}
		})
	}

	joinLoyalty(model) {
		model.joinLoyalty().then((res) => {
			if (res.status == 200) {
				window.alert('Operation successful')
				location.reload();
			}
		})
	}

	uploadAvatar(model) {
		model.uploadAvatar(model).then(x => {
			if(x.status == 200){
				let uploadImg = `<img src="${x.data}" />`
				$('.person_portrait .img').html(uploadImg)
			}
		})
	}

	getProductCode(model) {
		model.getProductCode(model).then(res => {
			let list= res.data.recommList
			model.productNumbers = list.toString()
			// this.getProduct(model);
			flash_fe_core_tool.$productPrice.ppByPns(model.productNumbers, flash_fe_core_tool.$CONSTANT.PDODUCT_LIST_TYPE.RECOMMENDATON).then(res=>{
				console.log("373===============",res)
				if(res && res.validProducts.length>0){
					let validProducts = res.validProducts
					let productlist = ''
					validProducts.forEach((item,index)=>{
						let imgURL = item.$img && item.$img.customThumbnail
						productlist += `
								<li>
									<img src="${(imgURL && imgURL.imageAddress)? imgURL.imageAddress:""}" alt="${item.summary}">
									<span class="item_title" data-tkey="smb.product.name"><#${item.summary}#></span>
									<span class="item_price">${item.priceInfo.$price.price}</span>
								</li>
								`
						$('.products_item ul').html(productlist)
					})
				}
			})
		}).catch(err => {
			reject(err)
		})
	}
}import Constant from "@constant/index.js";
import BaseView from "@model/core/View.js";
import Intercept from "@observer/Intercept.js";
import { reject } from "lodash-es";
export default class LadingPCView extends BaseView {

	constructor(model) {
		super(model);
		this._model = model;
		this._model._view = this;
		this._eventCenter = new LadingApi();
	}

	render() {
		this.regEvent();
		this.ladingEvent();
		this._eventCenter.getSmbBasic(this._model);
		// this._eventCenter.getLoyalty(this._model);
		// this._eventCenter.getProductCode(this._model);

	}

	regEvent() {
		let _this = this;
		$(".administrators").on("click", '.wallace .see_more_admin' , function () {
			$(".david_wallace").show()

		})
		$(".david_cross").on("click", function () {
			$(".david_wallace").hide()
		})
		$('.tier_rewards .rewards_right .rewards_button').on('click', function () {
			_this._eventCenter.joinLoyalty(_this._model);

		})
		$('.pro_progress').on('mouseover',function(e){
			if(_this._model.itdm == true){
				$('.consumption').show()
			}

		})
		$('.pro_progress').on('mouseleave ',function(e){
			$('.consumption').hide()
		})
		$('.scott_person').on('click', '.tier_view', function () {
			$('html,body').animate({ scrollTop: $(".tier_account").offset().top }, 300)
		})
		$('#uploadAvatar').on('change', function () {
			let file = $(this).get(0).files[0]
			if ("png,jpg,gif,jpeg".indexOf(file.name.substring(file.name.lastIndexOf(".") + 1)) == -1) {
				alert("Extension must be png,jpg,gif,jpeg!");
				return;
			}
			if (file.size > 1024 * 1024 * 3) {
				alert("File size must less than 3MB!")
				return;
			}
			var reader = new FileReader();
			reader.readAsDataURL(file);
			reader.onload = function (e) {
				_this._model.base64Code = reader.result
				_this._eventCenter.uploadAvatar(_this._model)
			}
		})
	}
}
class LadingApi {
	getSmbBasic(model) {
		console.log("model==============",model)
		model.getSmbBasic().then(res => {
			model.itdm = res.data.userProfileVO.isItdm
			console.log(model.itdm)
			let currencyCodes = res.data.smbCompanyVO.currencyCode
			let spendmoney = res.data.smbCompanyVO.endRevenue - res.data.smbCompanyVO.totalAmount
			let spendmoneyHtml = `Spend ${flash_fe_core_tool.$priceFormat.split3(spendmoney, currencyCodes)} more this year to unlock the Plus discount tier.`
			$('.consumption_pointer_details').html(spendmoneyHtml)
			let visit = `<a href="${res.data.smbTeleVO.smbCommunityUrl}" data-tkey="visit.the.community">Visit the Community</a>`
			$('.tier_optimize .visit_community').html(visit)
			//header image
			if (res.data.userProfileVO.filePath != null) {
				let uploadImg = `<img src="${res.data.userProfileVO.filePath}" />`
				$('.person_portrait .img').html(uploadImg)
				let html = ''
				html = `
				<div class="person_detail">
					<span class="tier_michael" data-tkey="smb.tier.name"><#${res.data.userProfileVO.firstName} ${res.data.userProfileVO.lastName}#></span>
					<span class="tier_dunder" data-tkey="smb.tier.companyName"><#${res.data.userProfileVO.companyName}#></span>
					<i class="tier_member"><i data-tkey="member.since"><#Member Since#></i> ${res.data.userProfileVO.createTime}</i>
					<i class="tier_view" data-tkey="view.account.details"><#View Account Details#></i>
				</div>
				`
				$('.scott_person').append(html)
			} else {
				let html = ''
				let f = res.data.userProfileVO.firstName
				let l = res.data.userProfileVO.lastName
				let fname = f.substr(0, 1)
				let lname = l.substr(0, 1)
				let uploadImg = `<div>${fname}${lname}</div>`
				$('.person_portrait .img').html(uploadImg)
				html = `
				<div class="person_detail">
					<span class="tier_michael">${res.data.userProfileVO.firstName} ${res.data.userProfileVO.lastName}</span>
					<span class="tier_dunder">${res.data.userProfileVO.companyName}</span>
					<i class="tier_member">Member Since ${res.data.userProfileVO.createTime}</i>
					<i class="tier_view">View Account Details</i>
				</div>
				`
				$('.scott_person').append(html)
			}

			// tierPicture
			let gradeImg = `<img src="${res.data.smbCompanyVO.tierPicture}">`
			$('.administrators .administrators_img').html(gradeImg)

			//tele
			let teleHtml = ''
			if(res.data.smbTeleVO.defaultTeleAccount == false){
				teleHtml += `
					<div class="member_help">
						<p class="member_help_title"><span data-tkey="Need.help"><#Need help#>?</span> <i data-tkey="Contact.your.Lenovo.Representative"><#Contact your Lenovo Representative#>:<i></p>
						<div class="member_help_container">
							<span class="container_img">
								<img src="//p1-ofp.lenovouat.com/fes/cms/2021/04/27/qq2e4qbsqh1ekdbd6xma9himsqckd6517829.svg" alt="">
							</span>
							<div class="container_detail">
								<p data-tkey="Dwight.Shrute"><#${res.data.smbTeleVO.teleAccount[0].firstName} ${res.data.smbTeleVO.teleAccount[0].lastName}#></p>
								<p class="tele_email">${res.data.smbTeleVO.teleAccount[0].email}</p>
								<p class="tete_phone_number">${res.data.smbTeleVO.teleAccount[0].phone}</p>
							</div>
						</div>
						<p>or <a href="${res.data.smbTeleVO.smbCommunityUrl}" class="tele_visit" data-tkey="visit.our.Community"><#visit our Community#></a> <i data-tkey="to.connect.with.other.PRO.members">to connect with other PRO members</i>. </p>
					</div>
				`
			}else{
				teleHtml += `
					<div class="itdm_help">
						<div class="help_img">
							<img src="http://p2-ofp.lenovouat.cn/fes/cms/2021/06/29/bzpbnl2jretasbghk1ry322bjb6l3s762295.jpg
							"
								alt="">
						</div>
						<div class="need_help">
							<span data-tkey="Need.help"><#Need help#>?</span>
							<span class="contans"><i data-tkey="Call.our.Small.Business.specialists.at"><#Call our Small Business specialists at#></i>
								<a href="#"> ${res.data.smbTeleVO.teleAccount[0].phone} </a> <i data-tkey="or"><#or#></i> <a href="${res.data.smbTeleVO.smbCommunityUrl}" data-tkey="visit.our.Community"><#visit our Community#></a>
								<i data-tkey="to.connect.with.other.SMB.professionals"><#to connect with other SMB professionals#></i>. </span>
						</div>
					</div>
				`
			}
			$('.tier_help').html(teleHtml)

			// bar image
			let tiergrade = res.data.smbCompanyVO.tierGrade
			let tierPicture = `<img src="${res.data.smbCompanyVO.tierPicture}"/>`
			if (res.data.smbCompanyVO.tierGrade == 1) {
				$('.ordinary').html(tierPicture)
			} else if (res.data.smbCompanyVO.tierGrade == 2) {
				$('.senior').html(tierPicture)
			} else if (res.data.smbCompanyVO.tierGrade == 3) {
				$('.honorable').html(tierPicture)
			}
			// debugger
			let itdmHtml = ''
			if (res.data.userProfileVO.isItdm == true) {
				let currentYearAmount =	flash_fe_core_tool.$priceFormat.split3(res.data.smbCompanyVO.currentYearAmount, currencyCodes)
				itdmHtml = `
					<span class="admin_menber" data-tkey="LenovoPRO.Pro.Tier.Member"><#LenovoPRO Pro Tier Member#></span>
					<div class="admin_isItadm" data-tkey="Annual.Spend">
						<#Annual Spend:#> ${currentYearAmount}
					</div>`
				$('.admin_detail').html(itdmHtml)
				if (tiergrade == 1) {
					if (res.data.smbCompanyVO.percentCurrent >= 50) {

						let widths = 2 * ($('.progress').width()) * (res.data.smbCompanyVO.percentCurrent - 50) / 100 + 'px'
						$('.consumption').css({"left":$('.pro_progress').width()+$('.progress').width()* (res.data.smbCompanyVO.percentCurrent - 50) / 100 + 'px'})
						$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
						if (res.data.smbCompanyVO.percentCurrent == 100) {
							$('.bar2 span').css({
								'width': '100%',
								'background': res.data.smbCompanyVO.tierColor,
								"border-top-right-radius": '5px',
								"border-bottom-right-radius": '5px',
							})
						} else {
							$('.bar2 span').css({ 'width': widths, 'background': res.data.smbCompanyVO.tierColor })
						}
					} else {
						let barWidth = 2 * ($('.progress').width()) * res.data.smbCompanyVO.percentCurrent / 100 + 'px'
						$('.bar1 span').css({ 'width': barWidth, 'background': res.data.smbCompanyVO.tierColor })
					}
				}
				if (tiergrade == 2) {
					$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar2 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
					if (res.data.smbCompanyVO.percentCurrent >= 50) {
						$('.consumption').css({"left":2*$('.pro_progress').width()+$('.progress').width()* (res.data.smbCompanyVO.percentCurrent - 50) / 100 + 'px'})
						let widths = 2 * ($('.progress').width()) * (res.data.smbCompanyVO.percentCurrent - 50) / 100 + 'px'

						$('.bar3 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
						if (res.data.smbCompanyVO.percentCurrent == 100) {
							$('.bar4 span').css({
								'width': '100%',
								'background': res.data.smbCompanyVO.tierColor,
								"border-top-right-radius": '5px',
								"border-bottom-right-radius": '5px',
							})
						} else {
							$('.bar4 span').css({ 'width': widths, 'background': res.data.smbCompanyVO.tierColor })
						}
					} else {
						let barWidth = 2 * ($('.progress').width()) * res.data.smbCompanyVO.percentCurrent / 100 + 'px'
						$('.bar3 span').css({ 'width': barWidth, 'background': res.data.smbCompanyVO.tierColor })
					}
				}

				if(tiergrade == 3){
					$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar2 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
					$('.bar3 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar4 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
				}

			}else{
				let itdmListLen= res.data.smbItdmListVO.itdmList.length
				itdmHtml = `
				<span class="admin_menber" data-tkey="LenovoPRO.Pro.Tier.Member"><#LenovoPRO Pro Tier Member#></span>
				<div class="admin_notitdm">
					<span class="admin" data-tkey="Your.Administrators"><#Your Administrators:#></span>
					<span class="wallace" data-tkey="David.Wallace"><#${res.data.smbItdmListVO.itdmList[0].name}#> <a class="see_more_admin">+${itdmListLen}more</a>
					<i><a href="${res.data.smbItdmListVO.itdmList[0].email}">${res.data.smbItdmListVO.itdmList[0].email}</a></i>
					</span>
				</div>`
				$('.admin_detail').html(itdmHtml)
				if(tiergrade == 2){
					$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar2 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
				}
				if(tiergrade == 3){
					$('.bar1 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar2 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
					$('.bar3 span').css({ 'width': '100%', 'background': res.data.smbCompanyVO.tierColor })
					$('.bar4 span').css({
						'width': '100%',
						'background': res.data.smbCompanyVO.tierColor,
						"border-top-right-radius": '5px',
						"border-bottom-right-radius": '5px',
					})
				}
			}

			// bar details
			// let arr = res.data.smbCompanyVO.companyTier;
			// $('.garde_detail').html('');
			// arr.forEach((item,index) => {
			// 	let detailsDom = `<div class="details">${item.description}</div>`;
			// 	$('.garde_detail').append(detailsDom);

			// });



			// email
			let itdmemail = res.data.smbItdmListVO.itdmList
			let emailHtml = ''
			itdmemail.forEach((item, index) => {
				emailHtml += `
					<li>
						<span>${(item.name==null)?'':item.name}</span>
						<i>${(item.email==null)?'':item.email}</i>
						<i>${(item.phoneNumber)==null?'':item.phoneNumber}</i>
					</li>
				`
			});
			$('.franklin-reallylongn ul').html(emailHtml)

		}).catch(err => {
			window.alert(err.msg)
		})
	}

	getLoyalty(model) {
		model.getLoyalty().then(res => {
			let loyaltyList = res.data
			let objLoyaltylist = loyaltyList.loyaltyUserInfoVO
			if (loyaltyList.storeToggle == true && loyaltyList.userToggle == true) {
				$('.tier_rewards .noloyalty_rewards').hide()
				let haveLoyalty = `
				<div class="loyalty_rewards">
					<div class="rewards_left">
						<span class="mylenovo_rewards">
							<img src="https://p2-ofp.static.pub/fes/cms/2021/06/05/i0xb3cnq76vmnkqcfsdugoqa78jz80947591.svg"
								alt="">
						</span>
						<span class="my_rewards">
							<p data-tkey="My.Rewards"><#My Rewards#></p>
							<i><#${objLoyaltylist.rewardsFormattedValue}#></i>
						</span>
						<span class="points">
							<p data-tkey="Available.Points"><#Available Points#></p>
							<i><#${objLoyaltylist.redeemablePointsFormat}#></i>
						</span>
					</div>
					<div class="rewards_right">
						<div class="right_since">
							<i data-tkey="rewards.member.since"><#Rewards Member Since#></i>  <i>${objLoyaltylist.joinLoyaltyYear}</i>
						</div>
						<div class="right_button">
							<a target="_blank" href="https://account.gl.lenovouat.com/us/smb/en/account/rewards/index.html" data-tkey="See.My.Rewards"><#See My Rewards#></a>
						</div>
					</div>
				</div>
				`
				$('.tier_rewards').html(haveLoyalty)
			}
			else {
				$('.tier_rewards .noloyalty_rewards').show()
			}
		})
	}

	joinLoyalty(model) {
		model.joinLoyalty().then((res) => {
			if (res.status == 200) {
				window.alert('Operation successful')
				location.reload();
			}
		})
	}

	uploadAvatar(model) {
		model.uploadAvatar(model).then(x => {
			if(x.status == 200){
				let uploadImg = `<img src="${x.data}" />`
				$('.person_portrait .img').html(uploadImg)
			}
		})
	}

	getProductCode(model) {
		model.getProductCode(model).then(res => {
			let list= res.data.recommList
			model.productNumbers = list.toString()
			// this.getProduct(model);
			flash_fe_core_tool.$productPrice.ppByPns(model.productNumbers, flash_fe_core_tool.$CONSTANT.PDODUCT_LIST_TYPE.RECOMMENDATON).then(res=>{
				console.log("373===============",res)
				if(res && res.validProducts.length>0){
					let validProducts = res.validProducts
					let productlist = ''
					validProducts.forEach((item,index)=>{
						let imgURL = item.$img && item.$img.customThumbnail
						productlist += `
								<li>
									<img src="${(imgURL && imgURL.imageAddress)? imgURL.imageAddress:""}" alt="${item.summary}">
									<span class="item_title" data-tkey="smb.product.name"><#${item.summary}#></span>
									<span class="item_price">${item.priceInfo.$price.price}</span>
								</li>
								`
						$('.products_item ul').html(productlist)
					})
				}
			})
		}).catch(err => {
			reject(err)
		})
	}
}]]

function test()
    local times = 1;
    local startTime = os.clock()
    while times < 10000 do
        t, result = splitByTag(test_str)
        if times == 2 then
            print(#t)
        end
        times = times + 1
    end
    local endTime = os.clock()
    print("case1 time used:", endTime - startTime)

    times = 1;
    local startTime = os.clock()
    while times < 10000 do
        tk = scanKeys(test_str)
        if times == 2 then
            print(#tk)
        end
        times = times + 1
    end
    local endTime = os.clock()
    print("case2 time used:", endTime - startTime)
end

--test()