import { LightningElement } from 'lwc';
import {  skeletonPosts } from 'c/clbinsUtils'

export default class ClbinsSkeletonSearchResults extends LightningElement {
  resultsSpiner = skeletonPosts
}