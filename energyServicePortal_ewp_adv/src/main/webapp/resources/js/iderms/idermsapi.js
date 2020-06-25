// iderms api 연동


	var idermsDevice = function(name, parent_did, device_type, metering_type, dashboard, billing, forecasting, detecting, capacity, capacity_unit, description) {
	  this.name = name;
	  this.parent_did = parent_did;
	  this.device_type = device_type;
	  this.metering_type = metering_type;
	  this.dashboard = dashboard;
	  this.billing = billing;
	  this.forecasting = forecasting;
	  this.detecting = detecting;
	  this.capacity = capacity;
	  this.capacity_unit = capacity_unit;
	  this.description = description;
	}


class IdermsClass {
	
    constructor(oid, login_id, password) {
		this.oid = oid;
		this.login_id = login_id;
		this.password = password;
		this.token = null;
    }
    
    
    // auth insert(post) 
	postAuthLogin() {
		
		var result_val = null;
		
	 	$.ajax({
	 		url: "http://iderms.enertalk.com:8443/auth/login",
	 		context: this,
		    type: "POST",
		    async: false,
		    data: JSON.stringify({"oid": this.oid,
			        "login_id": this.login_id,
			        "password": this.password}),
		    contentType: 'application/json; charset=UTF-8', 
		    success: function(result) {
		    	if (result != null) {
		    		this.token = result.token;
				}
			   
		    	result_val = result.token;
		   },
		   error: function(result, status, error) {
		     var kkk = 0;
		     kkk = 5;
		   }
		});
	 	
	 	return result_val;
	}

	
	// auth select(get)
//	getAuthMe() {
//		
//		var result_val = null;
//		
//	 	$.ajax({
// 		url: "http://iderms.enertalk.com:8443/auth/me",
// 		context: this,
//	    type: "get",
//	    async: false,
//	    data: JSON.stringify({"oid": this.oid,
//		        "login_id": this.login_id,
//		        "password": this.password}),
//	    contentType: 'application/json; charset=UTF-8; ' + 'Authorization: Bearer ' + token, 
//	    success: function(result) {
//	    	if (result != null) {
//	    		result_val.uid = result.uid;
//	    		result_val.login_id = result.login_id;
//	    		result_val.name = result.name;
//	    		result_val.oid = result.oid;
//	    		result_val.role = result.role;
////	    		  "uid": "ae6bef76-b985-4697-b422-84be676f29e1",
////	    		  "login_id": "hkits",
////	    		  "name": "HKITS_TEST",
////	    		  "oid": "dongseo",
////	    		  "role": 2, 
//			}
//	   },
//	   error: function(result, status, error) {
//	     var kkk = 0;
//	     kkk = 5;
//	   }
//	});
//	 	
//	 	return r_val;
//	}
	
	
	
//	// org select(get)
//	getOrgsOid(oid, includeUsers, includeSites, includeDevices, includeRtus) {
//		
//		var result_val = null;
//		
//		 $.ajax({
//		   url: "http://iderms.enertalk.com:8443/config/orgs" + "/" + oid + "?" + "includeUsers=" + includeUsers + "&" + "includeSites=" + includeSites + "&" + "includeDevices=" + includeDevices + "&" + "includeRtus=" + includeRtus,
//		   context: this,
//		   type: "get",
//		   async: false,
//		   data:{
//		     oid: oid, //"dongseo",
//		     includeUsers: includeUsers,
//		     includeSites: includeSites,
//		     includeDevices: includeDevices,
//		     includeRtus: includeRtus
//		   },
//		   success: function(result) {
//			   result_val = result;
//		   },
//		   error: function(result, status, error) {
//		     //error function or alert, return
//		     // error_getYearGenData(request, status, error);
//		   }
//		 });
//		
//		 return result_val;
//	}    	
	
	

	// site select(get)
	getSites(oid) {
		var result_val = null;
		
		  $.ajax({
			  url: "http://iderms.enertalk.com:8443/config/sites",
			  type: "get",
			  async: false,
			  data: {
			    oid: oid //"spower",
			  },
			  success: function (result) {
//			    $('#centerTbody tr td:nth-child(1)').text(Math.floor(result.length));
//			    let acPowerSum = 0;
			    result.forEach((site, siteIdx) => {
			    	
			    })
			    
			    result_val = result;
			  },
//			      $.ajax({
//			        url: "http://iderms.enertalk.com:8443/energy/sites",
//			        type: "get",
//			        async: false,
//			        data: {
//			          sid: site.sid,
//			          startTime: formData.startTime,
//			          endTime: formData.endTime,
//			          interval: "15min"
//			        },
//			        success: function (result) {//api 요청결과
//			          let generationSum = 0;
//			          let billingSum = 0;
//			          result.data[0].generation.items.map((e) => {generationSum += e.energy;});
//			          result.data[0].generation.items.map((e) => billingSum += e.billing);
//			          
//			          pieChart.series[0].data.forEach((e, idx) => {
//			            if (e.name === "태양광") {
//			              e.update({y: Math.floor(generationSum / 100)});
//			            } else if (e.name === "미사용량") {
//			              e.update({y: Math.floor((generationSum/(97280*2) )/ 100)});
//			            } else {
//			              e.update({y: 0});
//			            }
//			          });
//			          let prevVal = Number($('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(1) span').text());
//			          $('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(1) span').text(Math.floor(prevVal += (generationSum/1000)));
//			          let prevBillVal = Number($('#centerTbody tr td:nth-child(5)').text());
//			          $('#centerTbody tr td:nth-child(5)').text(Math.floor(prevBillVal += billingSum));
//			          $(`.dbclickopen.flag${siteIdx+1} td:nth-child(8)`).text(Math.floor(generationSum/1000)+'kWh');
//			          $(`.detail_info.list${siteIdx+1} li.clear:nth-child(3) span.fl:nth-child(2) em`).text(Math.floor(generationSum/1000));
//			        },
//			        error: function (result, status, error) {
//			          //error function or alert, return
//			          // error_getYearGenData(request, status, error);
//			        }
//			      });	
			   error: function(result, status, error) {

			   }
			});		
				
				return result_val;
			}
	
	
	
	
	// device select(get)
	getDevices(oid, sid) {
		
		var result_val = null;
		
		$.ajax({
 		url: "http://iderms.enertalk.com:8443/config/devices",
 		context: this,
	    type: "get",
	    async: false,
	    data:{
	    	oid: oid, //this.oid, //"dongseo",
	        sid: sid //this.sid //"72303fa5-990b-44fb-ab7f-8f27a41db446"
	    },
	    success: function(result) {
	    	result_val = result;
	   },
	   error: function(result, status, error) {

	   }
	});		
		
		return result_val;
	}
	
	
	// device insert(post)
	postDevices(oid, sid, device) {	
		
		var result_val = null;
		
		 $.ajax({
		   url: "http://iderms.enertalk.com:8443/config/devices" + "?" + "oid=" + oid + "&" + "sid=" + sid,
		   context: this,
		   type: "post",
		   async: false,
		    data: JSON.stringify({"name": device.name,
	    	  		"parent_did": device.parent_did,
		        	  "device_type": device.device_type,
		        	  "metering_type": device.metering_type,
		        	  "dashboard": device.dashboard,
		        	  "billing": device.billing,
		        	  "forecasting": device.forecasting,
		        	  "detecting": device.detecting,
		        	  "capacity": device.capacity,
		        	  "capacity_unit": device.capacity_unit,
		        	  "description": device.description}),
		        	  
	    contentType: 'application/json; charset=UTF-8',	   

	    success: function(result) {
	    	result_val = result;

		   },
		   error: function(result, status, error) {
		     var m = 0;
		     m = 5;
		   }
		 });
		 
		 
		 return result_val;
	}
	
	
	// device delete(delete)
	deleteDevice(sid, did) {
		//삭제로직 추가
//		var device_id = did;
		
//	     var oid = "dongseo";
//	     var sid = "72303fa5-990b-44fb-ab7f-8f27a41db446";
		var result_val = 0;
	     
	     
	 $.ajax({
	   url: "http://iderms.enertalk.com:8443/config/devices" + "/" + did + "?" + "sid=" + sid,
	   type: "delete",
	   async: false,
//		    data: JSON.stringify({"name": "인버터#1999",
//	 	  		"parent_did": null,
//		        	  "device_type": "INV_PV",
//		        	  "metering_type": 0,
//		        	  "dashboard": false,
//		        	  "billing": false,
//		        	  "forecasting": false,
//		        	  "detecting": false,
//		        	  "capacity": 125,
//		        	  "capacity_unit": "kW",
//		        	  "description": "string"}),
	// contentType: 'application/json; charset=UTF-8',	   
//		   data:{
//		     oid: "dongseo",
//		     sid: "72303fa5-990b-44fb-ab7f-8f27a41db446",
//		     requestBody: [{  "name": "인버터#99",
//			        	  		"parent_did": null,
//			        	  "device_type": "INV_PV",
//			        	  "metering_type": 0,
//			        	  "dashboard": false,
//			        	  "billing": false,
//			        	  "forecasting": false,
//			        	  "detecting": false,
//			        	  "capacity": 555,
//			        	  "capacity_unit": "kW",
//			        	  "description": "string"}]
//		   },
	   success: function(result) {
	     var k = 0;
	     k = 5;
	     result_val = result.count;

	   },
	   error: function(result, status, error) {
	     //error function or alert, return
	     // error_getYearGenData(request, status, error);
	     var m = 0;
	     m = 5;
	   }
	 });
	 
	 return result_val;
	}	
	
	

    // data status get raw
	getStatusRaw(dids) {
		
		var result_val = null;
		
		$.ajax({
 		//url: "http://iderms.enertalk.com:8443/status/raw" + "?" + "dids=" + did,
			url: "http://iderms.enertalk.com:8443/status/raw",
 		context: this,
	    type: "get",
	    async: false,
	    data:{
	    	dids: dids
	    },
	    success: function(result) {
	    	result_val = result;
	   },
	   error: function(result, status, error) {

	   }
	});		
		
		return result_val;
	}   
    
    
    
    
}


//
//
//
//	
//	var idermsApiUtil = function(oid, login_id, password) {
//		this.oid = oid;
//		this.login_id = login_id;
//		this.password = password;
//	}
//	
//	idermsApiUtil.prototype.postAuthLogin = function() {
//	 	$.ajax({
//	 		url: "http://iderms.enertalk.com:8443/auth/login",
////	 		dataType: 'json',
//		    type: "POST",
//		    async: false,
////	 	    data: JSON.stringify({"oid": "dongseo",
////	 		        "login_id": "hkits",
////	 		        "password": "11111111"}),
//		    data: JSON.stringify({"oid": this.oid,
//			        "login_id": this.login_id,
//			        "password": this.password}),
//		    contentType: 'application/json; charset=UTF-8', 
//		    success: function(result) {
//		    	if (result != null) {
//		    		this.token = result.token;
//				}
//			   
////		    	return this.token;
//		    	return result.token;
//		   },
//		   error: function(result, status, error) {
//		     //error function or alert, return
//		     // error_getYearGenData(request, status, error);
//		     var kkk = 0;
//		     kkk = 5;
//		   }
//		});
//	}
////
////	
////	var idermsApiUtil = {
////	  oid: 'string',
////	  login_id: 'string',
////	  password: 'string',
////      token: null,
////
////		// auth insert(login) 
////		postAuthLogin: function() {
////		 	$.ajax({
////		 		url: "http://iderms.enertalk.com:8443/auth/login",
//////		 		dataType: 'json',
////			    type: "POST",
////			    async: false,
//////		 	    data: JSON.stringify({"oid": "dongseo",
//////		 		        "login_id": "hkits",
//////		 		        "password": "11111111"}),
////			    data: JSON.stringify({"oid": this.oid,
////				        "login_id": this.login_id,
////				        "password": this.password}),
////			    contentType: 'application/json; charset=UTF-8', 
////			    success: function(result) {
////			    	if (result != null) {
////			    		this.token = result.token;
////					}
////				   
//////			    	return this.token;
////			    	return result.token;
////			   },
////			   error: function(result, status, error) {
////			     //error function or alert, return
////			     // error_getYearGenData(request, status, error);
////			     var kkk = 0;
////			     kkk = 5;
////			   }
////			});
////		},
////		
////		
//	
//	idermsApiUtil.prototype.getAuthMe = function() {
//	 	$.ajax({
// 		url: "http://iderms.enertalk.com:8443/auth/me",
//// 		dataType: 'json',
//	    type: "get",
//	    async: false,
//// 	    data: JSON.stringify({"oid": "dongseo",
//// 		        "login_id": "hkits",
//// 		        "password": "11111111"}),
//	    data: JSON.stringify({"oid": this.oid,
//		        "login_id": this.login_id,
//		        "password": this.password}),
//	    contentType: 'application/json; charset=UTF-8; ' + 'Authorization: Bearer ' + token, 
//	    success: function(result) {
//	    	if (result != null) {
//	    		//this.token = result.token;
//	    		var r_val;
//	    		r_val.uid = result.uid;
//	    		r_val.login_id = result.login_id;
//	    		r_val.name = result.name;
//	    		r_val.oid = result.oid;
//	    		r_val.role = result.role;
////	    		  "uid": "ae6bef76-b985-4697-b422-84be676f29e1",
////	    		  "login_id": "hkits",
////	    		  "name": "HKITS_TEST",
////	    		  "oid": "dongseo",
////	    		  "role": 2, 
//			}
//		   
//	    	//return this.token;
//	   },
//	   error: function(result, status, error) {
//	     //error function or alert, return
//	     // error_getYearGenData(request, status, error);
//	     var kkk = 0;
//	     kkk = 5;
//	   }
//	});
//	}
//	
//	
//	
////		// auth select(get) 
////		getAuthMe: function() {
////		 	$.ajax({
////		 		url: "http://iderms.enertalk.com:8443/auth/me",
//////		 		dataType: 'json',
////			    type: "get",
////			    async: false,
//////		 	    data: JSON.stringify({"oid": "dongseo",
//////		 		        "login_id": "hkits",
//////		 		        "password": "11111111"}),
////			    data: JSON.stringify({"oid": this.oid,
////				        "login_id": this.login_id,
////				        "password": this.password}),
////			    contentType: 'application/json; charset=UTF-8; ' + 'Authorization: Bearer ' + token, 
////			    success: function(result) {
////			    	if (result != null) {
////			    		//this.token = result.token;
////			    		var r_val;
////			    		r_val.uid = result.uid;
////			    		r_val.login_id = result.login_id;
////			    		r_val.name = result.name;
////			    		r_val.oid = result.oid;
////			    		r_val.role = result.role;
//////			    		  "uid": "ae6bef76-b985-4697-b422-84be676f29e1",
//////			    		  "login_id": "hkits",
//////			    		  "name": "HKITS_TEST",
//////			    		  "oid": "dongseo",
//////			    		  "role": 2, 
////					}
////				   
////			    	//return this.token;
////			   },
////			   error: function(result, status, error) {
////			     //error function or alert, return
////			     // error_getYearGenData(request, status, error);
////			     var kkk = 0;
////			     kkk = 5;
////			   }
////			});
////		},		
////		
//	
//	
//	idermsApiUtil.prototype.getDevices = function(oid, sid) {
//		$.ajax({
// 		url: "http://iderms.enertalk.com:8443/config/devices",
//	    type: "get",
//	    async: false,
//	    data:{
//	    	oid: oid, //this.oid, //"dongseo",
//	        sid: sid //this.sid //"72303fa5-990b-44fb-ab7f-8f27a41db446"
//	    },
//	    success: function(result) {
//	    	return result;
//	   },
//	   error: function(result, status, error) {
//
//	   }
//	});		
//	}
//	
//	
//	
////		// device select(get)
////		getDevices: function(oid, sid) {
////			$.ajax({
////		 		url: "http://iderms.enertalk.com:8443/config/devices",
////			    type: "get",
////			    async: false,
////			    data:{
////			    	oid: oid, //this.oid, //"dongseo",
////			        sid: sid //this.sid //"72303fa5-990b-44fb-ab7f-8f27a41db446"
////			    },
////			    success: function(result) {
////			    	return result;
////			   },
////			   error: function(result, status, error) {
////
////			   }
////			});
////		},
////		
//	
//	
//	idermsApiUtil.prototype.postDevices = function(oid, sid, device) {	
//		 $.ajax({
//		   url: "http://iderms.enertalk.com:8443/config/devices" + "?" + "oid=" + oid + "&" + "sid=" + sid,
//		   type: "post",
//		   async: false,
//		    data: JSON.stringify({"name": device.name,
//	    	  		"parent_did": device.parent_did,
//		        	  "device_type": device.device_type,
//		        	  "metering_type": device.metering_type,
//		        	  "dashboard": device.dashboard,
//		        	  "billing": device.billing,
//		        	  "forecasting": device.forecasting,
//		        	  "detecting": device.detecting,
//		        	  "capacity": device.capacity,
//		        	  "capacity_unit": device.capacity_unit,
//		        	  "description": device.description}),
//		        	  
//		        	  
////		        	  {"name": device.name,
////			    	  		"parent_did": null,
////				        	  "device_type": "INV_PV",
////				        	  "metering_type": 0,
////				        	  "dashboard": false,
////				        	  "billing": false,
////				        	  "forecasting": false,
////				        	  "detecting": false,
////				        	  "capacity": 125,
////				        	  "capacity_unit": "kW",
////				        	  "description": "string"}),
////				        	  
//		        	  
////		        	  
////		        	  idermsDevice = function() {
////		        			this.name = name;
////		        			this.parent_did = parent_did;
////		        			this.device_type = device_type;
////		        			this.metering_type = metering_type;
////		        			this.dashboard = dashboard;
////		        			this.billing = billing;
////		        			this.forecasting = forecasting;
////		        			this.detecting = detecting;
////		        			this.capacity = capacity;
////		        			this.capacity_unit = capacity_unit;
////		        			this.description = description;
//		        	  
//		        	  
//	    contentType: 'application/json; charset=UTF-8',	   
////	 	   data:{
////	 	     oid: "dongseo",
////	 	     sid: "72303fa5-990b-44fb-ab7f-8f27a41db446",
////	 	     requestBody: [{  "name": "인버터#99",
////	 		        	  		"parent_did": null,
////	 		        	  "device_type": "INV_PV",
////	 		        	  "metering_type": 0,
////	 		        	  "dashboard": false,
////	 		        	  "billing": false,
////	 		        	  "forecasting": false,
////	 		        	  "detecting": false,
////	 		        	  "capacity": 555,
////	 		        	  "capacity_unit": "kW",
////	 		        	  "description": "string"}]
////	 	   },
//		   success: function(result) {
//		     var k = 0;
//		     k = 5;
//		   },
//		   error: function(result, status, error) {
//		     //error function or alert, return
//		     // error_getYearGenData(request, status, error);
//		     var m = 0;
//		     m = 5;
//		   }
//		 });
//	}
//	
////		// device insert(post)
////		postDevices: function(oid, sid, device) {
//////		     var oid = "dongseo";
//////		     var sid = "72303fa5-990b-44fb-ab7f-8f27a41db446";	 
////		 $.ajax({
////		   url: "http://iderms.enertalk.com:8443/config/devices" + "?" + "oid=" + oid + "&" + "sid=" + sid,
////		   type: "post",
////		   async: false,
////		    data: JSON.stringify({"name": device.name,
////	    	  		"parent_did": device.parent_did,
////		        	  "device_type": device.device_type,
////		        	  "metering_type": device.metering_type,
////		        	  "dashboard": device.dashboard,
////		        	  "billing": device.billing,
////		        	  "forecasting": device.forecasting,
////		        	  "detecting": device.detecting,
////		        	  "capacity": device.capacity,
////		        	  "capacity_unit": device.capacity_unit,
////		        	  "description": device.description}),
////		        	  
////		        	  
//////		        	  {"name": device.name,
//////			    	  		"parent_did": null,
//////				        	  "device_type": "INV_PV",
//////				        	  "metering_type": 0,
//////				        	  "dashboard": false,
//////				        	  "billing": false,
//////				        	  "forecasting": false,
//////				        	  "detecting": false,
//////				        	  "capacity": 125,
//////				        	  "capacity_unit": "kW",
//////				        	  "description": "string"}),
//////				        	  
////		        	  
//////		        	  
//////		        	  idermsDevice = function() {
//////		        			this.name = name;
//////		        			this.parent_did = parent_did;
//////		        			this.device_type = device_type;
//////		        			this.metering_type = metering_type;
//////		        			this.dashboard = dashboard;
//////		        			this.billing = billing;
//////		        			this.forecasting = forecasting;
//////		        			this.detecting = detecting;
//////		        			this.capacity = capacity;
//////		        			this.capacity_unit = capacity_unit;
//////		        			this.description = description;
////		        	  
////		        	  
////	    contentType: 'application/json; charset=UTF-8',	   
//////	 	   data:{
//////	 	     oid: "dongseo",
//////	 	     sid: "72303fa5-990b-44fb-ab7f-8f27a41db446",
//////	 	     requestBody: [{  "name": "인버터#99",
//////	 		        	  		"parent_did": null,
//////	 		        	  "device_type": "INV_PV",
//////	 		        	  "metering_type": 0,
//////	 		        	  "dashboard": false,
//////	 		        	  "billing": false,
//////	 		        	  "forecasting": false,
//////	 		        	  "detecting": false,
//////	 		        	  "capacity": 555,
//////	 		        	  "capacity_unit": "kW",
//////	 		        	  "description": "string"}]
//////	 	   },
////		   success: function(result) {
////		     var k = 0;
////		     k = 5;
////		   },
////		   error: function(result, status, error) {
////		     //error function or alert, return
////		     // error_getYearGenData(request, status, error);
////		     var m = 0;
////		     m = 5;
////		   }
////		 });
////		},
////		
////		
//	
//	
//	idermsApiUtil.prototype.getOrgsOid = function(oid, includeUsers, includeSites, includeDevices, includeRtus) {
//		
//		 $.ajax({
//		   url: "http://iderms.enertalk.com:8443/config/orgs/dongseo",
//		   type: "get",
//		   async: false,
//		   data:{
//		     oid: oid, //"dongseo",
//		     includeUsers: includeUsers,
//		     includeSites: includeSites,
//		     includeDevices: includeDevices,
//		     includeRtus: includeRtus
//		   },
//		   success: function(result) {
//			   
//		   },
//		   error: function(result, status, error) {
//		     //error function or alert, return
//		     // error_getYearGenData(request, status, error);
//		   }
//		 });
//		
//	}
//	
////		// org select(get)
////		getOrgsOid: function(oid, includeUsers, includeSites, includeDevices, includeRtus) {
////			 $.ajax({
////				   url: "http://iderms.enertalk.com:8443/config/orgs/dongseo",
////				   type: "get",
////				   async: false,
////				   data:{
////				     oid: oid, //"dongseo",
////				     includeUsers: includeUsers,
////				     includeSites: includeSites,
////				     includeDevices: includeDevices,
////				     includeRtus: includeRtus
////				   },
////				   success: function(result) {
////					   
////				   },
////				   error: function(result, status, error) {
////				     //error function or alert, return
////				     // error_getYearGenData(request, status, error);
////				   }
////				 });			
////		}
////		
////		
////		
////	} 
////
//
//
//
//
//// function getDevice() {
//
////  const $tbody = $('#device_list1');
////  $tbody.empty();
////  let tbodyStr = ``;
// 
////  $.ajax({
////    url: "http://iderms.enertalk.com:8443/config/orgs",
////    type: "get",
////    async: false,
////    data:{
////      oid: "dongseo",
////    },
////    success: function(result) {
////      result.forEach(site=>{
////        $.ajax({
////          url: "http://iderms.enertalk.com:8443/energy/sites",
////          type: "get",
////          async: false,
////          data:{
////            sid: site.sid,
////            startTime: formData.startTime,
////            endTime:formData.endTime,
////            interval:"hour"
////          },
////          success: function(result) {//api 요청결과
////            let generationSum = 0;
////            result.data[0].generation.items.forEach((e) => {generationSum += e.energy;});
////            let siteName =site.name.replace(/\s/g, "");
////            if(generationSum>=1000){
////              generationSum = (generationSum/1000);
////            }else if(generationSum>=1000000){
////              generationSum = (generationSum/1000000);
////            }
////            tbodyStr += `<tr><th>${siteName}</th><td>${Math.floor(generationSum)}</td>`;
//           
////          },
////          error: function(result, status, error) {
////            //error function or alert, return
////            // error_getYearGenData(request, status, error);
////          }
////        });
////        $.ajax({
////          url: "http://iderms.enertalk.com:8443/energy/forecasting/sites",
////          type: "get",
////          async: false,
////          data:{
////            sid: site.sid,
////            startTime: formData.startTime,
////            endTime:formData.endTime,
////            interval:"hour"
////          },
////          success: function(result) {//api 요청결과
////            let generationForecastSum = 0;
////            result.data[0].generation.items.map((e)=>generationForecastSum+=e.energy);
////            if(generationForecastSum>=1000){
////              generationForecastSum = (generationForecastSum/1000);
////            }else if(generationForecastSum>=1000000){
////              generationForecastSum = (generationForecastSum/1000000);
////            }
////            tbodyStr += `<td>${Math.floor(generationForecastSum)}</td></tr>`;
////          },
////          error: function(result, status, error) {
////            //error function or alert, return
////            // error_getYearGenData(request, status, error);
////          }
////        });
////      })
////    },
////    error: function(result, status, error) {
////      //error function or alert, return
////      // error_getYearGenData(request, status, error);
////    }
////  });
////  $tbody.append(tbodyStr);
////  drawPeakChart3();
//// }

