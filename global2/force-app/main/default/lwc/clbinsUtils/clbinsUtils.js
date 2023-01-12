import { LightningElement } from "lwc";


export default class ClbinsUtils extends LightningElement { }


export const filterCmsTopic = (posts = [], topic) => {
  return posts.filter((entry) => {
    const { tematica } = entry.contentNodes;
    const cmsTopic = tematica.value.toLowerCase();
    return cmsTopic === topic.toLowerCase();
  });
};


export const formatDate = (strDate) => {
  const dateMilliseconds = new Date(strDate).getTime();
  const date = new Date(dateMilliseconds);
  return date.toLocaleString("es", {
    month: "short",
    day: "numeric",
    year: "numeric",
    timeZone: "UTC"
  });
};

export const unEscape = (htmlStr) => {
  htmlStr = htmlStr.replace(/&lt;/g , "<");	 
  htmlStr = htmlStr.replace(/&gt;/g , ">");     
  htmlStr = htmlStr.replace(/&quot;/g , "\"");  
  htmlStr = htmlStr.replace(/&#39;/g , "\'");   
  htmlStr = htmlStr.replace(/&amp;/g , "&");
  htmlStr = htmlStr.replace(/&#92;/g , "\\");
  return htmlStr;
};