export const OMNIDEF = {"userTimeZone":-300,"userProfile":"Administrador del sistema 2","userName":"cristiaam@cloudblue.us.ta","userId":"00522000004MjvzAAC","userCurrencyCode":"COP","timeStamp":"2023-01-14T06:04:14.830Z","sOmniScriptId":"0jN2200000000lkEAA","sobjPL":{},"RPBundle":"","rMap":{},"response":null,"propSetMap":{"stylesheet":{"lightningRtl":"","newportRtl":"","lightning":"","newport":""},"wpm":false,"visualforcePagesAvailableInPreview":{},"trackingCustomData":{},"timeTracking":false,"stepChartPlacement":"right","ssm":false,"showInputWidth":false,"seedDataJSON":{},"saveURLPatterns":{},"saveObjectId":"%ContextId%","saveNameTemplate":null,"saveForLaterRedirectTemplateUrl":"vlcSaveForLaterAcknowledge.html","saveForLaterRedirectPageName":"sflRedirect","saveExpireInDays":null,"saveContentEncoded":false,"rtpSeed":false,"pubsub":false,"persistentComponent":[{"sendJSONPath":"","sendJSONNode":"","responseJSONPath":"","responseJSONNode":"","render":false,"remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"remoteMethod":"","remoteClass":"","preTransformBundle":"","postTransformBundle":"","modalConfigurationSetting":{"modalSize":"lg","modalHTMLTemplateId":"vlcProductConfig.html","modalController":"ModalProductCtrl"},"label":"","itemsKey":"cartItems","id":"vlcCart"},{"render":false,"remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"remoteMethod":"","remoteClass":"","preTransformBundle":"","postTransformBundle":"","modalConfigurationSetting":{"modalSize":"lg","modalHTMLTemplateId":"","modalController":""},"label":"","itemsKey":"knowledgeItems","id":"vlcKnowledge"}],"message":{},"lkObjName":null,"knowledgeArticleTypeQueryFieldsMap":{},"hideStepChart":true,"errorMessage":{"custom":[]},"enableKnowledge":false,"elementTypeToHTMLTemplateMapping":{},"disableUnloadWarn":true,"currencyCode":"","consoleTabTitle":null,"consoleTabLabel":"New","consoleTabIcon":"custom:custom18","cancelType":"SObject","cancelSource":"%ContextId%","cancelRedirectTemplateUrl":"vlcCancelled.html","cancelRedirectPageName":"OmniScriptCancelled","bLK":false,"autoSaveOnStepNext":false,"autoFocus":false,"allowSaveForLater":false,"allowCancel":true},"prefillJSON":"{}","lwcId":"8f114dc0-20d1-d103-6e55-06d560e977ba","labelMap":{"GenerateDocumentWord":"Generate Document:GenerateDocumentWord","EmailWebTemplate-PDF":"Generate Document:EmailWebTemplate-PDF","Generate Document":"Generate Document","Set Generation Options":"Set Generation Options","ServerValues":"ServerValues","SetValues":"SetValues","GetDocumentTemplateById":"GetDocumentTemplateById","GetDocumentTemplates":"GetDocumentTemplates","PlanAbierto":"PlanAbierto","PlanCerrado":"PlanCerrado","STV1":"STV1"},"labelKeyMap":{},"errorMsg":"","error":"OK","dMap":{},"depSOPL":{},"depCusPL":{},"cusPL":{},"children":[{"type":"Set Values","propSetMap":{"pubsub":false,"message":{},"ssm":false,"wpm":false,"HTMLTemplateId":"","show":null,"showPersistentComponent":[true,false],"elementValueMap":{"TemplateType":"Microsoft Word .DOCX Template","EnterObject":{"TemplateType":"Microsoft Word .DOCX Template","ObjectId":"%ObjectId%"}},"label":"SetValues1","controlWidth":12,"aggElements":{}},"offSet":0,"name":"STV1","level":0,"indexInParent":0,"bHasAttachment":false,"bEmbed":false,"bSetValues":true,"JSONPath":"STV1","lwcId":"lwc0"},{"type":"Set Values","propSetMap":{"pubsub":false,"message":{},"ssm":false,"wpm":false,"HTMLTemplateId":"","show":{"group":{"rules":[{"field":"PlanValue","condition":"=","data":"Cerrado"}],"operator":"AND"}},"showPersistentComponent":[true,false],"elementValueMap":{"TemplateName":"SLIP AP 1"},"label":"SetValues2","controlWidth":12,"aggElements":{}},"offSet":0,"name":"PlanCerrado","level":0,"indexInParent":1,"bHasAttachment":false,"bEmbed":false,"bSetValues":true,"JSONPath":"PlanCerrado","lwcId":"lwc1"},{"type":"Set Values","propSetMap":{"controlWidth":12,"label":"SetValues2","elementValueMap":{"TemplateName":"SLIP AP 2"},"showPersistentComponent":[true,false],"show":{"group":{"rules":[{"field":"PlanValue","condition":"=","data":"Abierto"}],"operator":"AND"}},"HTMLTemplateId":"","wpm":false,"ssm":false,"message":{},"pubsub":false,"aggElements":{}},"offSet":0,"name":"PlanAbierto","level":0,"indexInParent":2,"bHasAttachment":false,"bEmbed":false,"bSetValues":true,"JSONPath":"PlanAbierto","lwcId":"lwc2"},{"type":"DataRaptor Extract Action","propSetMap":{"wpm":false,"validationRequired":"Step","ssm":false,"showPersistentComponent":[false,false],"show":null,"responseJSONPath":"","responseJSONNode":"","remoteTimeout":30000,"redirectTemplateUrl":"vlcAcknowledge.html","redirectPreviousWidth":3,"redirectPreviousLabel":"Previous","redirectPageName":"","redirectNextWidth":3,"redirectNextLabel":"Next","pubsub":false,"postMessage":"Done","message":{},"label":"GetDocumentTemplates","inProgressMessage":"In Progress","failureNextLabel":"Continue","failureGoBackLabel":"Go Back","failureAbortMessage":"Are you sure?","failureAbortLabel":"Abort","errorMessage":{"default":null,"custom":[]},"enableDefaultAbort":false,"enableActionMessage":false,"disOnTplt":false,"dataRaptor Input Parameters":[{"inputParam":"templateType","element":"TemplateType"},{"inputParam":"TemplateName","element":"TemplateName"}],"controlWidth":12,"bundle":"DocGenSample-ExtractDocumentTemplatesV2","HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"GetDocumentTemplates","level":0,"indexInParent":3,"bHasAttachment":false,"bEmbed":false,"bDataRaptorExtractAction":true,"JSONPath":"GetDocumentTemplates","lwcId":"lwc3"},{"type":"DataRaptor Extract Action","propSetMap":{"wpm":false,"validationRequired":"Step","ssm":false,"showPersistentComponent":[true,false],"show":null,"responseJSONPath":"","responseJSONNode":"","remoteTimeout":30000,"redirectTemplateUrl":"vlcAcknowledge.html","redirectPreviousWidth":3,"redirectPreviousLabel":"Previous","redirectPageName":"","redirectNextWidth":3,"redirectNextLabel":"Next","pubsub":false,"postMessage":"Done","message":{},"label":"GetDocumentTemplateById","inProgressMessage":"In Progress","ignoreCache":false,"failureNextLabel":"Continue","failureGoBackLabel":"Go Back","failureAbortMessage":"Are you sure?","failureAbortLabel":"Abort","errorMessage":{"default":null,"custom":[]},"enableDefaultAbort":false,"enableActionMessage":false,"dataRaptor Input Parameters":[{"inputParam":"templateId","element":"templateId"}],"controlWidth":12,"businessEvent":"","businessCategory":"","bundle":"DocGenSample-ExtractDocumentTemplateByIdLWC","HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"GetDocumentTemplateById","level":0,"indexInParent":4,"bHasAttachment":false,"bEmbed":false,"bDataRaptorExtractAction":true,"JSONPath":"GetDocumentTemplateById","lwcId":"lwc4"},{"type":"Set Values","propSetMap":{"wpm":false,"ssm":false,"showPersistentComponent":[false,false],"show":null,"pubsub":false,"message":{},"label":null,"elementValueMap":{"templateType":"%TemplateType%","selectedTemplate":{"VersionNumber":"%selectedTemplate:VersionNumber%","TemplateType":"%selectedTemplate:TemplateType%","Select":true,"Name":"%selectedTemplate:Name%","Id":"%selectedTemplate:Id%"}},"disOnTplt":false,"controlWidth":12,"HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"SetValues","level":0,"indexInParent":5,"bHasAttachment":false,"bEmbed":false,"bSetValues":true,"JSONPath":"SetValues","lwcId":"lwc5"},{"type":"Set Values","propSetMap":{"pubsub":false,"message":{},"ssm":false,"wpm":false,"HTMLTemplateId":"","show":null,"showPersistentComponent":[true,false],"elementValueMap":{"GenerationOptions":{"UseTemplateDRExtract":"Yes","PdfGenerationSource":"VlocityClientSide","DownloadFileFormat":"all","DocumentViewer":"VlocityClientSideViewer","DocumentTitle":"TestDocument","DocumentGenerationFontSource":"Rich Text Editor Font","DocGenerationMechanism":"VlocityClientSide","AttachFileFormat":"docx"}},"label":"","controlWidth":12,"aggElements":{}},"offSet":0,"name":"ServerValues","level":0,"indexInParent":6,"bHasAttachment":false,"bEmbed":false,"bSetValues":true,"JSONPath":"ServerValues","lwcId":"lwc6"},{"type":"Set Values","propSetMap":{"wpm":false,"ssm":false,"showPersistentComponent":[false,false],"show":null,"pubsub":false,"message":{},"label":null,"elementValueMap":{"useTemplateDRExtract":"=%GenerationOptions:UseTemplateDRExtract%","pdfGenerationSource":"=%GenerationOptions:PdfGenerationSource%","downloadFileFormat":"=%GenerationOptions:DownloadFileFormat%","documentViewer":"=%GenerationOptions:DocumentViewer%","documentTitle":"=%GenerationOptions:DocumentTitle%","documentGenerationFontSource":"=%GenerationOptions:DocumentGenerationFontSource%","docGenerationMechanism":"=%GenerationOptions:DocGenerationMechanism%","attachFileFormat":"=%GenerationOptions:AttachFileFormat%"},"disOnTplt":false,"controlWidth":12,"HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"Set Generation Options","level":0,"indexInParent":7,"bHasAttachment":false,"bEmbed":false,"bSetValues":true,"JSONPath":"Set Generation Options","lwcId":"lwc7"},{"type":"Step","propSetMap":{"validationRequired":true,"showPersistentComponent":[false,false],"show":null,"saveMessage":"","saveLabel":"","remoteTimeout":30000,"remoteOptions":{},"remoteMethod":"","remoteClass":"","previousWidth":"4","previousLabel":"Atras","nextWidth":"4","nextLabel":"Next","label":"","knowledgeOptions":{"typeFilter":"","remoteTimeout":30000,"publishStatus":"Online","language":"English","keyword":"","dataCategoryCriteria":""},"instructionKey":"","instruction":"","errorMessage":{"default":null,"custom":[]},"disOnTplt":false,"conditionType":"Hide if False","completeMessage":"Are you sure you want to complete the script?","completeLabel":"Complete","chartLabel":null,"cancelMessage":"Are you sure?","cancelLabel":"Cancel","allowSaveForLater":true,"HTMLTemplateId":"","uiElements":{"Generate Document":""},"aggElements":{"GenerateDocumentWord":""}},"offSet":0,"name":"Generate Document","level":0,"indexInParent":8,"bHasAttachment":false,"bEmbed":false,"response":null,"inheritShowProp":null,"children":[{"response":null,"level":1,"indexInParent":0,"eleArray":[{"type":"Email Action","rootIndex":8,"response":null,"propSetMap":{"businessEvent":"","businessCategory":"","enableActionMessage":false,"enableDefaultAbort":false,"errorMessage":{"default":null,"custom":[]},"pubsub":false,"message":{},"ssm":false,"wpm":false,"HTMLTemplateId":"","show":null,"showPersistentComponent":[true,false],"redirectPreviousWidth":3,"redirectPreviousLabel":"Previous","redirectNextWidth":3,"redirectNextLabel":"Next","redirectTemplateUrl":"vlcAcknowledge.html","redirectPageName":"","validationRequired":"Step","failureAbortMessage":"Are you sure?","failureGoBackLabel":"Go Back","failureAbortLabel":"Abort","failureNextLabel":"Continue","postMessage":"Done","inProgressMessage":"In Progress","remoteTimeout":30000,"docList":"","staticDocList":[],"contentVersionList":"%pdfGenContentVersionId%","attachmentList":"","fileAttachments":"","OrgWideEmailAddress":"","emailInformation":{"setHtmlBody":false,"emailBody":"This is a test email","emailSubject":"This is a test email from uat","bccAddressList":[],"ccAddressList":["cristiaam@cloudblue.us"],"toAddressList":["cristiaam@gmail.com"]},"emailTemplateInformation":{"whatId":"","saveAsActivity":false,"emailTargetObjectId":"","emailTemplateName":""},"useTemplate":false,"label":"Enviar por correo","controlWidth":3},"name":"EmailWebTemplate-PDF","level":1,"JSONPath":"Generate Document:EmailWebTemplate-PDF","indexInParent":0,"index":0,"children":[],"bHasAttachment":false,"bEmailAction":true,"lwcId":"lwc80-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":1,"eleArray":[{"type":"Custom Lightning Web Component","rootIndex":8,"response":null,"propSetMap":{"show":null,"lwcName":"vlocity_ins__clmOsDocxGenerateDocument","label":"Generate Document Word","hide":false,"disOnTplt":false,"customAttributes":[{"source":"%EnterObject:ObjectId%","name":"context-id"},{"source":"%selectedTemplate%","name":"selected-template"},{"source":"false","name":"debug"},{"source":"Slip de Cotización","name":"document-title"}],"controlWidth":12,"conditionType":"Hide if False","bStandalone":false},"name":"GenerateDocumentWord","level":1,"JSONPath":"Generate Document:GenerateDocumentWord","indexInParent":1,"index":0,"children":[],"bHasAttachment":false,"bcustomlightningwebcomponent1":true,"lwcId":"lwc81-0"}],"bHasAttachment":false}],"bAccordionOpen":false,"bAccordionActive":false,"bStep":true,"isStep":true,"JSONPath":"Generate Document","lwcId":"lwc8"}],"bReusable":true,"bpVersion":13,"bpType":"docGenerationSample","bpSubType":"singleDocxLwc","bpLang":"English","bHasAttachment":false,"lwcVarMap":{"EnterObject":{"ObjectId":null},"selectedTemplate":null}};