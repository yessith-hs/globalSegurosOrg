import { LightningElement, api, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import getContentList from "@salesforce/apex/ManagedContentController.getContentList";
import basePath from "@salesforce/community/basePath";

export default class CmsBlogList extends NavigationMixin(LightningElement) {
  @api maxEntries;
  @api pageTitle;

  blogs;


  @wire(getContentList, {
    page: 0,
    pageSize: "$maxEntries",
    language: "es",
    filterby: "Articulos_Global"
  })
  wiredContent({ data, error }) {
    if (data) {
      this.blogs = data.map((entry) => {
         const {  Title, Descripcion,Imagen1 } = entry.contentNodes;
        return {
          key: entry.contentKey,
          title: Title.value,
          descripcion: Descripcion.value,
          imageUrl: `${basePath}/sfsites/c${Imagen1.url}`,
          imageAltText: Imagen1.value
        };
      });
      this.error = undefined;
    }
    if (error) {
      console.log("Error: " + JSON.stringify(error));
    }
  }

  handleClick(event) {
    this[NavigationMixin.Navigate]({
      type: "standard__webPage",
      attributes: {
        url: `${basePath}/blog/post?blogId=${event.currentTarget.dataset.id}`
      }
    });
  }
}