var demInfo= {
	"native":"unknown",
	"bilingual":"unknown",
	"gender":"unknown",
	"aoa":"unknown",
	"age":"unknown",
	"participant_id":"unknown",
	"startTime":"unknown",
	"condition":"unknown",
	"rateWordList":"unknown",
	"targetWordList":"unknown",
}

var currentIndex=0;
var demoWords=["this","is","where","the","list","of","words","will","appear"]
var wordRateDict={}
var rateCounter=0
var confCounter=0
var wordRateTicker=0
var testWords=["bubble",,"change","skate","singer","faith","sweet","learn","nothing","machine","mitten","stapler","bucket","life","muppet","ball","skill","source","change","cache","add","object"]
var workerId="volunteer"

var started=false;
var dataWritten=false

var wordDemoDone=false

var basic=io("/");
basic.on('connect', function() {
	console.log("Connected to word demo server!");
});


basic.on('catch stims',function (data) {
	demInfo.targetWordList=data["memoryTargets"]
	demInfo.rateWordList=data["ratingTargets"]
	demInfo.participant_id=data["participantID"]
	demInfo.condition=data["condition"]
	demInfo.startTime=data["startTime"]
	makeWordRating(demInfo.rateWordList)
});

basic.on('write result',function(data) {
	dataWritten=true
})




function makeWordRating(wList) {
	//eventually trigger upon receipt of stims

	for (var i=0;i<wList.length;i++) {
		var seenOrder=demInfo.targetWordList.indexOf(wList[i]);
		var wasSeen;
		if (seenOrder>=0) {
			wasSeen=true
		} else {
			wasSeen=false
		}
		wordRateDict[wList[i]]={"seenClickCount":0,
								"rateClickCount":0,
								"target":wList[i],
								"rateOrder":i,
								"wasSeen":wasSeen,
								"seenOrder":seenOrder,
								"thinksSeen":"unknown",
								"confidence":"unknown"
							}
	}

	$(".wordrateRow-"+wList[0]).show();
}


function wordLoop(wordList) {
	if (currentIndex > wordList.length) {
		if (wordDemoDone) {
			$("#videoBreak").show()
		} else {
			$(".endWordDemo").show()
			$("#endDemo").show();
			wordDemoDone=true
		}
		$("#wordLoop").hide();
	} else {
		setTimeout(function() {
			$("#fixationCrossWord").text(wordList[currentIndex])
			setTimeout(function() {
				$("#fixationCrossWord").text("+")
			},500)
			currentIndex+=1
			wordLoop(wordList)
		}, 1500)//CHECK THIS TIMING
	}
}

$(document).ready(function() {
	$("#welcome").show()
	$(".spinner").hide()

	$("#primaryConsent").click(function() {
		$("#welcome").hide()
		$("#demInfo").show()
		console.log("asking for stims.")
		basic.emit('get stims')
		
	})

	$("#humanTest").click(function() {
		$("#demStart").hide()
		var enteredTest = $("#bCheck").val()
		enteredTest=enteredTest.toLowerCase()
		var sCheck=Number($("#bSlideCheck").val())
		if ((sCheck==100 || sCheck==1) && enteredTest=="for style!") {
			$("#itsHuman").show();
			$(".age").show()
		} else {
			$("#itsAbomination").show()
		}
	})

	$("#enterAge").click(function() {
		var myage=Number($("#age").val())
		if (myage<18 || myage>99 || $("#age").val()=="") {
			$("#age").css("border-color","red")
			$(".needAge").show()
		} else {
			//write age to demInfo
			demInfo.age=myage
			$(".age").hide()
			$(".gender").show()
		}
	})

	$("#gender-status input").on('change',function() {
		//genderChosen=true
		var wutclicked=$('input[name=gender]:checked',"#gender-status").val()
		demInfo.gender=wutclicked
		$(".gender").hide()
		$(".langs").show()
	});

	$("#english-status input").on('change',function() {
		//englishChosen=true

		var wutclicked=$('input[name=engstatus]:checked',"#english-status").val()
		$(".langs").hide()
		if (wutclicked=="EngL2") {
			demInfo.bilingual=true
			demInfo.native=false
			$(".nnEng").show()
		} else {
			demInfo.native=true
			$(".nativeEng").show()
		}
	});

	$("#biling-status input").on('change',function() {
		var wutclicked=$('input[name=bilingstatus]:checked',"#biling-status").val()
		$("#demInfo").hide()
		$("#instructOne").show()
		if(wutclicked=="biling") {
			demInfo.bilingual=true
		} else {
			demInfo.bilingual=false
		}
	});

	$("#enterAoA").click(function() {
		///get aoa for non natives
		var myage=Number($("#aoa").val())
		if ((myage<99 || myage>=0) && $("#aoa").val()!="") {
			$("#demInfo").hide()
			$("#instructOne").show()
			demInfo.aoa=myage
		} else {
			$(".needAge").show()
		}
	});

	$(".showWordDemo").click(function() {
		currentIndex=0
		$(".instruct").hide()
		$("#wordLoop").show()
		wordLoop(demoWords)
	})

	$("#showWordList").click(function() {
		currentIndex=0
		$(".endWordDemo").hide();
		$("#endDemo").hide();
		$("#wordLoop").show();
		wordLoop(demInfo.targetWordList)

	})

	/*$(".showPicDemo").click(function() {
		currentIndex=0
		$(".instruct").hide()
		$("#picLoop").show()
		imageLoop(demoPics)
	})

	$("#showPicList").click(function() {
		currentIndex=0
		$(".endPicDemo").hide();
		$("#endDemo").hide();
		$("#picLoop").show();
		imageLoop(demInfo.targetPicList)
	})*/

	/*$("#endPicBreak").click(function() {
		$("#videoBreakA").hide()
		$("#endDemo").hide()
		///show instructions first?
		$("#instructPicRatings").show()
	});*/
	$("#endBreak").click(function() {
		$("#videoBreak").hide()
		$("#endDemo").hide()
		$("#instructWordRatings").show()
	});

	/*$("#startPicRate").click(function() {
		$("#picRaterSection").show()
		$("#instructPicRatings").hide()
	})

	$(".pic-seenGroup").click(function() {
		var clickedid=$(this).attr('id')
		var clickinfo=clickedid.split("-")
		console.log(clickinfo)
		var curTarget=clickinfo[1]
		var result=clickinfo[0]
		if (result=="seen") {
			result=true
		} else {
			result=false
		}
		if (picRateDict[curTarget].seenClickCount == 0) {
			//if this is the first click, register in overall count
			rateCounter+=1
		}
		picRateDict[curTarget].seenClickCount+=1
		picRateDict[curTarget].thinksSeen=result
		if (picRateDict[curTarget].seenClickCount > 0 && picRateDict[curTarget].rateClickCount > 0) {
			$(".endRateRow").show()
		}
		if(result) {//if you selected seen,
			$(this).removeClass('btn-outline-success').addClass('btn-success')//remove the outline and fill it
			$("#notseen-"+curTarget).removeClass('btn-danger').addClass('btn-outline-danger')
		} else {
			$(this).removeClass('btn-outline-danger').addClass('btn-danger')
			$("#seen-"+curTarget).removeClass('btn-success').addClass('btn-outline-success')
		}
	});

	$(".pic-confGroup").click(function() {
		var clickedid=$(this).attr('id')
		var clickinfo=clickedid.split("-")
		var curTarget=clickinfo[1]
		var result=clickinfo[0]

		$(".pic-confGroup").removeClass('btn-primary').addClass('btn-outline-primary')
		$(this).removeClass('btn-outline-primary').addClass('btn-primary')

		if (picRateDict[curTarget].rateClickCount == 0) {
			//if this is the first click, register in overall count
			confCounter+=1
		}
		picRateDict[curTarget].rateClickCount+=1
		picRateDict[curTarget].confidence=result
		if (picRateDict[curTarget].seenClickCount > 0 && picRateDict[curTarget].rateClickCount > 0) {

			$(".endRateRow").show()
		}

		picRateDict[curTarget].confidence=result
	});*/

	$(".word-seenGroup").click(function() {
		var clickedid=$(this).attr('id')
		var clickinfo=clickedid.split("-")
		//console.log(clickinfo)
		var curTarget=clickinfo[1]
		var result=clickinfo[0]
		if (result=="seen") {
			result=true
		} else {
			result=false
		}
		if (wordRateDict[curTarget].seenClickCount == 0) {
			//if this is the first click, register in overall count
			rateCounter+=1
		}
		wordRateDict[curTarget].seenClickCount+=1
		wordRateDict[curTarget].thinksSeen=result
		if (wordRateDict[curTarget].seenClickCount > 0 && wordRateDict[curTarget].rateClickCount > 0) {
			$(".endWordRateRow").show()
		}
		if(result) {//if you selected seen,
			$(this).removeClass('btn-outline-success').addClass('btn-success')//remove the outline and fill it
			$("#notseen-"+curTarget+"-word").removeClass('btn-danger').addClass('btn-outline-danger')
		} else {
			$(this).removeClass('btn-outline-danger').addClass('btn-danger')
			$("#seen-"+curTarget+"-word").removeClass('btn-success').addClass('btn-outline-success')
		}
	});

	$(".word-confGroup").click(function() {
		var clickedid=$(this).attr('id')
		var clickinfo=clickedid.split("-")
		var curTarget=clickinfo[1]
		var result=clickinfo[0]

		$(".word-confGroup").removeClass('btn-primary').addClass('btn-outline-primary')
		$(this).removeClass('btn-outline-primary').addClass('btn-primary')

		if (wordRateDict[curTarget].rateClickCount == 0) {
			//if this is the first click, register in overall count
			confCounter+=1
		}
		wordRateDict[curTarget].rateClickCount+=1
		wordRateDict[curTarget].confidence=result
		if (wordRateDict[curTarget].seenClickCount > 0 && wordRateDict[curTarget].rateClickCount > 0) {

			$(".endWordRateRow").show()
		}

		wordRateDict[curTarget].confidence=result
	});

	$(".nextRate-word").click(function() {
		var oldTarget=demInfo.rateWordList[wordRateTicker]
		$(".wordrateRow-"+oldTarget).hide()
		wordRateTicker+=1
		if (wordRateTicker==demInfo.rateWordList.length) {
			$("#wordRaterSection").hide()
			var finalData={"demInfo":demInfo,"ratings": wordRateDict}
			basic.emit('final data',finalData)
			setTimeout(function() {
				if (!dataWritten) {
					$("#writeSuccess").hide()
					$("#writeError").show()
				}
			},3000)
			$("#endStudy").show()
		} else {
			var newTarget=demInfo.rateWordList[wordRateTicker]
			var prog=Math.floor((wordRateTicker/140)*100)
			$("#wordRateProgress").css("width",prog.toString()+"%")
			$("#wordRateProgress").attr("aria-valuenow",prog.toString())
			$("#wordpercentProg").text(prog.toString())
			$(".endWordRateRow").hide()
			$(".wordrateRow-"+newTarget).show()
		}
	})


	$("#startWordRate").click(function() {
		$("#instructWordRatings").hide()
		$("#wordRaterSection").show()
	})


	var iframeA = $("#vidA");

    var playerA = new Vimeo.Player(iframeA);

    playerA.on('ended', function() {
    	console.log("detected end of Video A")
    	$("#vidA").hide()
		$("#endBreak").show()

    });

    $("#showdebrief").click(function() {
    	$("#debrief").modal('show')
    })


})