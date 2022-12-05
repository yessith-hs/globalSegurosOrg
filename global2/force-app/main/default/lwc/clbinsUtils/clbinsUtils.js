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