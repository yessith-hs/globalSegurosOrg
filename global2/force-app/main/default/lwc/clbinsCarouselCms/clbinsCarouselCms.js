import { LightningElement, api, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import getContentList from "@salesforce/apex/ManagedContentController.getContentList";
import basePath from "@salesforce/community/basePath";
import { formatDate } from "c/clbinsUtils";

export default class ClbinsCarouselCms extends NavigationMixin(
  LightningElement
) {
  @api topic;
  @api title;
  @api url;
  @api srcimg;

  posts;

  @wire(getContentList, {
    page: 0,
    pageSize: 10,
    language: "es",
    filterby: "$topic"
  })
  wiredContent({ data, error }) {
    if (data) {
      this.posts = data.map((entry) => {
        const { Title, Descripcion, Imagen } = entry.contentNodes;
        const date = formatDate(entry.publishedDate);

        return {
          key: entry.contentKey,
          date,
          title: Title.value,
          descripcion: Descripcion.value,
          imageUrl: `${basePath}/sfsites/c${Imagen.url}`,
          imageAltText: Imagen.value
        };
      });
      this.error = undefined;
    }
    if (error) {
      console.log("Error: " + JSON.stringify(error));
    }
  }
}