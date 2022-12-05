import { LightningElement, api, wire} from "lwc";
import getContentList from "@salesforce/apex/ManagedContentController.getContentList";
import basePath from "@salesforce/community/basePath";
import { formatDate } from "c/clbinsUtils";
export default class ClbinsListPost extends LightningElement {
  @api topic;
  posts;
  maxEntries = 2;
  hasEntries = true;


  @wire(getContentList, {
    page: 0,
    pageSize: "$maxEntries",
    language: "es",
    filterby: "$topic"
  })
  wiredContent({ data, error }) {
    console.log(
      "🚀 ~ file: clbinsListPost.js:18 ~ ClbinsListPost ~ hasEntries",
      this.hasEntries
    );


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

         console.log("original", data.length);
    console.log("post", this.posts.length);

      this.error = undefined;
    }
    if (error) {
      console.log("Error: " + JSON.stringify(error));
    }
  }

  handleGetEntries() {
    this.maxEntries += 2;
  }

  renderedCallback() {
    console.log("new render");
  }
}