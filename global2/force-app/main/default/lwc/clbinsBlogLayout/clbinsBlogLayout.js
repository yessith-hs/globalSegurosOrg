import { LightningElement, track, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import baseUrl from "@salesforce/community/basePath";
import getContent from "@salesforce/apex/ManagedContentController.getContent";
import basePath from "@salesforce/community/basePath";
import { formatDate } from "c/clbinsUtils";



// * Assets
import URL_HEADER from "@salesforce/resourceUrl/header";
import URL_AVATAR from "@salesforce/resourceUrl/avatar";

export default class ClbinsBlogLayout extends LightningElement {
  headerImg = URL_HEADER;
  avatarImg = URL_AVATAR;
  educationalUrl = baseUrl;

  @track blogId;
  topicUrl;
  _topic;
  _date;
  _title;
  _descripcion;
  _body;
  _autor;
  _imageUrl;
  _imageAltText;
  bodydos;

  // * get url topic
  URL_TOPICS = {
    "Orientación educativa": `${baseUrl}/conexion-global/orientacion-educativa`,
    "Desarrollo integral": `${baseUrl}/conexion-global/desarrollo-integral`,
    "Habilidades socioemocionales": `${baseUrl}/conexion-global/habilidades-socioemocionales`
  };

  // * get id post
  @wire(CurrentPageReference)
  pageReference({ state }) {
    if (state && state.blogId) {
      this.blogId = state.blogId;
    }
  }

  // * get data post
  @wire(getContent, {
    contentId: "$blogId",
    page: 0,
    pageSize: 1,
    language: "es",
    filterby: ""
  })
  wiredContent({ data, error }) {
    if (data) {
      const { Title, Descripcion, Portada, Publicacion, Autor, tematica } =
        data;

      const date = formatDate(data.publishedDate);
      console.log(
        "🚀 ~ file: clbinsBlogLayout.js ~ line 71 ~ ClbinsBlogLayout ~ wiredContent ~ Publicacion.value;",
        data
      );

      this._topic = tematica.value;
      this._date = date;
      this._title = Title.value;
      this._descripcion = Descripcion.value;
      this._body = Publicacion.value;
      this.bodydos = Publicacion.value;
      this._autor = Autor.value;
      this._imageUrl = basePath + "/sfsites/c" + Portada.unauthenticatedUrl;
      this._imageAltText = Portada.altText;
      this.error = undefined;
      this.topicUrl = this.URL_TOPICS[this._topic]
        ? this.URL_TOPICS[this._topic]
        : baseUrl;
    }
    if (error) {
      console.log("Error: " + JSON.stringify(error));
    }
  }

  get topic() {
    return this._topic;
  }

  get date() {
    return this._date;
  }

  get title() {
    return this._title;
  }

  get descripcion() {
    return this._descripcion;
  }

  get body() {
    return this._body;
  }

  get autor() {
    return this._autor;
  }

  get imageUrl() {
    return this._imageUrl;
  }

  get backgroundStyle() {
    return `min-height: 19.169rem;
    background-image: url(${this._imageUrl});
    background-repeat:no-repeat;
    background-size:cover;
    background-position:center;
    position: relative;`;
  }



  // renderedCallback() {
  //   console.log("renderedCallback ...");

  //   const container = this.template.querySelector(".container");
  //   container.insertAdjacentHTML("beforeend", this._body);
  // }
}