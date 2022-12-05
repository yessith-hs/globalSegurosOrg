import { LightningElement, api, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import getContentList from "@salesforce/apex/ManagedContentController.getContentList";
import basePath from "@salesforce/community/basePath";
import { formatDate } from "c/clbinsUtils";

export default class ClbinsHeadThematicLine extends NavigationMixin(
  LightningElement
) {
  @api topic;
  @api icon;
  @api title;
  @api image;
  @api content;

  posts;

  @wire(getContentList, {
    page: 0,
    pageSize: 3,
    language: "es",
    filterby: "$topic"
  })
  wiredContent({ data, error }) {
    if (data) {
      this.posts = data.map((entry) => {
        const { Title, Descripcion, Imagen } = entry.contentNodes;
        // const date = formatDate(fechapublicacion.value);
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

  handleClick(event) {
    this[NavigationMixin.Navigate]({
      type: "standard__webPage",
      attributes: {
        url: `${basePath}/conexion-global/post?blogId=${event.currentTarget.dataset.id}`
      }
    });
  }
}