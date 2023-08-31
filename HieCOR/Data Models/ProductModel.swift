//
//  ProductModel.swift
//  HieCOR
//
//  Created by Deftsoft on 21/01/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import Foundation

struct ProductAttributeDetail {
    var key: String!
    //var values: [Attributes]!
    var valuesAttribute: [AttributesModel]!
}

struct ProductItemMetaFieldsDetail {
    var key: String!
    var valuesMetaFields: [ItemMetaFieldssModel]!
}
struct ProductVariationDetail {
    var key: String!
    var valuesVariation: [VariationModel]!
}

struct ProductSurchageVariationDetail {
    var key: String!
    var valuesSurchargeVariation: [SurchageModel]!
}

struct AttributesData {
    var attributeId: String!
    var productId: String!
    var attributeType: String!
    var attributeName: String!
    var attributeHide: String!
    var attributeRequired: String!
    var attributeValues: JSONArray?
}

struct Attributes {
    var variationId: String!
    var attributeId: String!
    var attributeName: String!
    var attributeValueId: String!
    var price: Double!
    var isRadio: Bool!
    var isSelected: Bool!
    var jsonArray: JSONArray?
}

struct AttributesModel{
    var attribute_id: String!
    var product_id: String!
    var attribute_type: String!
    var attribute_value: String!
    var attribute_name: String!
    var attribute_hide: String!
    var attribute_required: String!
    var isSelected: Bool!
    var jsonArray: JSONArray?
}
struct ItemMetaFieldssModel{
    var product_lookup_id: String!
    var name: String!
    var value: String!
    var label: String!
    var itemMetaValue: String!
}
struct AttributeValues {
    var attribute_value_id : String!
    var attribute_value : String!
    var isSelect : Bool!
    var attribute_id :String!
}

struct VariationModel {
    var variation_id : String!
    var variation_price : String!
    var variation_original_price : String!
    var variation_msrp : String!
    var variation_price_special : String!
    var variation_price_special_date_start : String!
    var variation_price_special_date_end : String!
    var variation_wholesale_price : String!
    var variation_price_surcharge : String!
    var variation_stock : String!
    var variation_upc : String!
    var variation_product_code : String!
    var variation_description : String!
    var variation_use_parent_stock : String!
    var variation_taxable : Bool?
    var variation_use_parent_upc : String!
    var variation_use_parent_price : String!
    var jsonArray: JSONArray?
}

struct SurchageModel {
    
    var variation_id : String!
    var variation_price : String!
    var variation_original_price : String!
    var variation_msrp : String!
    var variation_price_special : String!
    var variation_price_special_date_start : String!
    var variation_price_special_date_end : String!
    var variation_wholesale_price : String!
    var variation_price_surcharge : String!
    var variation_price_surchargeClone : String!
    var variation_stock : String!
    var variation_upc : String!
    var variation_product_code : String!
    var variation_description : String!
    var variation_use_parent_stock : String!
    var variation_taxable : Bool?
    var variation_use_parent_upc : String!
    var variation_use_parent_price : String!
    var showAdditinalPriceInput : Bool?
    var jsonArray: JSONArray?

}

class AttributeSubCategory {
    var tempCategory = [AttributeValues]()
    
    public static let shared = AttributeSubCategory()
    private init() {}
    
    func getAttribute(with jsonArray: JSONArray, attrId: String) -> [AttributeValues] {
        var attributes = [AttributeValues]()
        var value = AttributeValues()
        
        for valData in jsonArray {
            value.attribute_value = valData["attribute_value"] as? String ?? ""
            value.attribute_value_id = valData["attribute_value_id"] as? String ?? ""
            value.attribute_id = attrId
            value.isSelect = valData["isSelect"]as? Bool ?? false
            
            attributes.append(value)
        }
        
        return attributes
    }
    func getAttributeForPanyNow(with jsonArray: JSONArray, attrId: String,selectData: JSONArray) -> [AttributeValues] {
        var attributes = [AttributeValues]()
        var value = AttributeValues()
        
        for valData in jsonArray {
            for selectDict in selectData{
                if attrId == selectDict["attribute_id"] as? String ?? "" {
                    if let dictValues = selectDict["attribute_value_id"] as? [String] {
                        for val in dictValues {
                            if valData["attribute_value_id"] as? String ?? "" == val as? String ?? "" {
                                value.attribute_value = valData["attribute_value"] as? String ?? ""
                                value.attribute_value_id = val
                                value.attribute_id = attrId
                                value.isSelect = valData["isSelect"]as? Bool ?? true
                                attributes.append(value)
                            }
                        }
                    }
                }
            }
        }
        return attributes
    }
    func getUpdateAttribute(with jsonArray: JSONArray, isSelected: Bool = false, index: Int, type: String, attributeId: String) -> [AttributeValues] {
        var attributes = [AttributeValues]()
        var value = AttributeValues()
        
        for i in 0..<jsonArray.count {
            
            let attrVal = jsonArray[i]
            
            if i == index {
                value.attribute_value = attrVal["attribute_value"] as? String ?? ""
                value.attribute_value_id = attrVal["attribute_value_id"] as? String ?? ""
                value.isSelect = isSelected
                value.attribute_id = attributeId
            } else {
                value.attribute_value = attrVal["attribute_value"] as? String ?? ""
                value.attribute_value_id = attrVal["attribute_value_id"] as? String ?? ""
                value.attribute_id = attributeId
                value.isSelect = (type == "radio") ? false : attrVal["isSelect"] as? Bool
            }
            
            attributes.append(value)
        }
        
        return attributes
    }
    func getProductDetailSurchargeVariationStructNewData(jsonArray: JSONArray, price:String, attId:String) -> [ProductSurchageVariationDetail] {
        var newProductDetails = [ProductSurchageVariationDetail]()
        for dict in jsonArray {
            var newProductDetail = ProductSurchageVariationDetail()
            var values = [SurchageModel]()
            
            if let dictValues = dict["values"] as? JSONArray {
                for dictValue in dictValues {
                    var value = SurchageModel()
                    let hh = dictValue["jsonArray"] as? JSONArray ?? JSONArray()
                    var attvalueId = ""
                    for list in hh {
                        attvalueId = (list as NSDictionary).value(forKey: "attribute_value_id") as! String
                    }
                    
                    if attId == attvalueId {
                        value.variation_id = dictValue["variationId"] as? String ?? ""
                        value.variation_price = dictValue["variationPrice"] as? String ?? ""
                        value.variation_original_price = dictValue["variationOriginalPrice"] as? String ?? ""
                        value.variation_msrp = dictValue["variationMsrp"] as? String ?? ""
                        value.variation_price_special = dictValue["variationPriceSpecial"] as? String ?? ""
                        value.variation_price_special_date_start = dictValue["variationPriceSpecialDateStart"] as? String ?? ""
                        value.variation_price_special_date_end = dictValue["variationPriceSpecialDateEnd"] as? String ?? ""
                        value.variation_wholesale_price = dictValue["variationWholesalePrice"] as? String ?? ""
                        value.variation_price_surcharge = dictValue["variationPriceSurcharge"] as? String ?? ""
                        value.variation_stock = dictValue["variationStock"] as? String ?? ""
                        value.variation_upc = dictValue["variationUpc"] as? String ?? ""
                        value.variation_product_code = dictValue["variationProductCode"] as? String ?? ""
                        value.variation_description = dictValue["variationDescription"] as? String ?? ""
                        value.variation_use_parent_stock = dictValue["variationUseParentStock"] as? String ?? ""
                        value.variation_taxable = dictValue["variation_taxable"] as? Bool ?? true
                        value.variation_use_parent_upc = dictValue["variationUseParentUpc"] as? String ?? ""
                        value.variation_use_parent_price = dictValue["variationUseParentPrice"] as? String ?? ""
                        value.showAdditinalPriceInput = dictValue["showAdditinalPriceInput"] as? Bool ?? false
                        value.variation_price_surchargeClone = price
                        
                        value.jsonArray = dictValue["jsonArray"] as? JSONArray ?? JSONArray()
                    } else {
                        value.variation_id = dictValue["variationId"] as? String ?? ""
                        value.variation_price = dictValue["variationPrice"] as? String ?? ""
                        value.variation_original_price = dictValue["variationOriginalPrice"] as? String ?? ""
                        value.variation_msrp = dictValue["variationMsrp"] as? String ?? ""
                        value.variation_price_special = dictValue["variationPriceSpecial"] as? String ?? ""
                        value.variation_price_special_date_start = dictValue["variationPriceSpecialDateStart"] as? String ?? ""
                        value.variation_price_special_date_end = dictValue["variationPriceSpecialDateEnd"] as? String ?? ""
                        value.variation_wholesale_price = dictValue["variationWholesalePrice"] as? String ?? ""
                        value.variation_price_surcharge = dictValue["variationPriceSurcharge"] as? String ?? ""
                        value.variation_stock = dictValue["variationStock"] as? String ?? ""
                        value.variation_upc = dictValue["variationUpc"] as? String ?? ""
                        value.variation_product_code = dictValue["variationProductCode"] as? String ?? ""
                        value.variation_description = dictValue["variationDescription"] as? String ?? ""
                        value.variation_use_parent_stock = dictValue["variationUseParentStock"] as? String ?? ""
                        value.variation_taxable = dictValue["variation_taxable"] as? Bool ?? true
                        value.variation_use_parent_upc = dictValue["variationUseParentUpc"] as? String ?? ""
                        value.variation_use_parent_price = dictValue["variationUseParentPrice"] as? String ?? ""
                        value.showAdditinalPriceInput = dictValue["showAdditinalPriceInput"] as? Bool ?? false
                        value.variation_price_surchargeClone = dictValue["variation_price_surchargeClone"] as? String
                        
                        value.jsonArray = dictValue["jsonArray"] as? JSONArray ?? JSONArray()
                    }
                                    
                    values.append(value)
                }
            }
            newProductDetail.key = dict["key"] as? String ?? ""
            newProductDetail.valuesSurchargeVariation = values
            newProductDetails.append(newProductDetail)
        }
        return newProductDetails
    }
    
    func getUpdateSurchargeVariation(with jsonArray: JSONArray, index: Int, price: String, attrId: String) -> [ProductSurchageVariationDetail] {
        var newProductDetails = [ProductSurchageVariationDetail]()
        var newProductDetail = ProductSurchageVariationDetail()
        var values = [SurchageModel]()
        var surcharge = [SurchageModel]()
        var valSurcharge = SurchageModel()
        let surchargeDetail = getProductDetailSurchargeVariationStructNewData(jsonArray: jsonArray, price: "", attId: attrId)
        for i in 0..<surchargeDetail.count {
            var value = SurchageModel()
            
            let arrayData  = surchargeDetail[i].valuesSurchargeVariation as [SurchageModel] as NSArray
            let surchargeModel = arrayData[0] as! SurchageModel
            var attvalueId = ""
            
            for list in surchargeModel.jsonArray! {
                attvalueId = (list as NSDictionary).value(forKey: "attribute_value_id") as! String
            }
            
            if attvalueId == attrId {
                valSurcharge.variation_id = surchargeModel.variation_id //attrVal["variation_id"] as? String ?? ""
                valSurcharge.variation_price = surchargeModel.variation_price//attrVal["variation_price"] as? String ?? ""
                valSurcharge.variation_original_price = surchargeModel.variation_original_price // attrVal["variation_original_price"] as? String ?? ""
                valSurcharge.variation_msrp = surchargeModel.variation_msrp //attrVal["variation_msrp"] as? String ?? ""
                valSurcharge.variation_price_special = surchargeModel.variation_price_special//attrVal["variation_price_special"] as? String ?? ""
                valSurcharge.variation_price_special_date_start = surchargeModel.variation_price_special_date_start//attrVal["variation_price_special_date_start"] as? String ?? ""
                valSurcharge.variation_price_special_date_end = surchargeModel.variation_price_special_date_end//attrVal["variation_price_special_date_end"] as? String ?? ""
                valSurcharge.variation_wholesale_price = surchargeModel.variation_wholesale_price//attrVal["variation_wholesale_price"] as? String ?? ""
                valSurcharge.variation_price_surcharge = surchargeModel.variation_price_surcharge //attrVal["variation_price_surcharge"] as? String ?? ""
                valSurcharge.variation_price_surchargeClone = price
                valSurcharge.variation_stock = surchargeModel.variation_stock//attrVal["variation_stock"] as? String ?? ""
                valSurcharge.variation_upc = surchargeModel.variation_upc//attrVal["variation_upc"] as? String ?? ""
                valSurcharge.variation_product_code = surchargeModel.variation_product_code//attrVal["variation_product_code"] as? String ?? ""
                valSurcharge.variation_description = surchargeModel.variation_description//attrVal["variation_description"] as? String ?? ""
                valSurcharge.variation_use_parent_stock = surchargeModel.variation_use_parent_stock//attrVal["variation_use_parent_stock"] as? String ?? ""
                valSurcharge.variation_taxable = surchargeModel.variation_taxable//attrVal["variation_taxable"] as? Bool ?? false
                valSurcharge.variation_use_parent_upc = surchargeModel.variation_use_parent_upc//attrVal["variation_use_parent_upc"] as? String ?? ""
                valSurcharge.variation_use_parent_price = surchargeModel.variation_use_parent_price//attrVal["variation_use_parent_price"] as? String ?? ""
                valSurcharge.showAdditinalPriceInput = surchargeModel.showAdditinalPriceInput//attrVal["showAdditinalPriceInput"] as? Bool ?? false
                valSurcharge.jsonArray = surchargeModel.jsonArray//attrVal["jsonArray"] as? JSONArray ?? JSONArray()
            } else {
                
                valSurcharge.variation_id = surchargeModel.variation_id //attrVal["variation_id"] as? String ?? ""
                valSurcharge.variation_price = surchargeModel.variation_price//attrVal["variation_price"] as? String ?? ""
                valSurcharge.variation_original_price = surchargeModel.variation_original_price // attrVal["variation_original_price"] as? String ?? ""
                valSurcharge.variation_msrp = surchargeModel.variation_msrp //attrVal["variation_msrp"] as? String ?? ""
                valSurcharge.variation_price_special = surchargeModel.variation_price_special//attrVal["variation_price_special"] as? String ?? ""
                valSurcharge.variation_price_special_date_start = surchargeModel.variation_price_special_date_start//attrVal["variation_price_special_date_start"] as? String ?? ""
                valSurcharge.variation_price_special_date_end = surchargeModel.variation_price_special_date_end//attrVal["variation_price_special_date_end"] as? String ?? ""
                valSurcharge.variation_wholesale_price = surchargeModel.variation_wholesale_price//attrVal["variation_wholesale_price"] as? String ?? ""
                valSurcharge.variation_price_surcharge = surchargeModel.variation_price_surcharge //attrVal["variation_price_surcharge"] as? String ?? ""
                valSurcharge.variation_price_surchargeClone = surchargeModel.variation_price_surchargeClone
                valSurcharge.variation_stock = surchargeModel.variation_stock//attrVal["variation_stock"] as? String ?? ""
                valSurcharge.variation_upc = surchargeModel.variation_upc//attrVal["variation_upc"] as? String ?? ""
                valSurcharge.variation_product_code = surchargeModel.variation_product_code//attrVal["variation_product_code"] as? String ?? ""
                valSurcharge.variation_description = surchargeModel.variation_description//attrVal["variation_description"] as? String ?? ""
                valSurcharge.variation_use_parent_stock = surchargeModel.variation_use_parent_stock//attrVal["variation_use_parent_stock"] as? String ?? ""
                valSurcharge.variation_taxable = surchargeModel.variation_taxable//attrVal["variation_taxable"] as? Bool ?? false
                valSurcharge.variation_use_parent_upc = surchargeModel.variation_use_parent_upc//attrVal["variation_use_parent_upc"] as? String ?? ""
                valSurcharge.variation_use_parent_price = surchargeModel.variation_use_parent_price//attrVal["variation_use_parent_price"] as? String ?? ""
                valSurcharge.showAdditinalPriceInput = surchargeModel.showAdditinalPriceInput//attrVal["showAdditinalPriceInput"] as? Bool ?? false
                valSurcharge.jsonArray = surchargeModel.jsonArray//attrVal["jsonArray"] as? JSONArray ?? JSONArray()
                
            }
            
            values.append(valSurcharge)
        }
        newProductDetail.key = ""
        newProductDetail.valuesSurchargeVariation = values
        newProductDetails.append(newProductDetail)
        
        return newProductDetails
    }
    func attributevalueConvertJSon(with attributes: [AttributeValues], attributeId: String) -> JSONArray {
        
        var jsonArrayValue = JSONArray()
        var dictValue = JSONDictionary()
        
        //jsonArrayValue = attributes
        
        for val in attributes {
            dictValue["attribute_value"] = val.attribute_value
            dictValue["attribute_value_id"] = val.attribute_value_id
            dictValue["isSelect"] = val.isSelect
            dictValue["attribute_id"] = attributeId
            
            jsonArrayValue.append(dictValue)
        }
        
        return jsonArrayValue
    }
}


class ProductModel {
    
    //MARK: Variables
    var tempProductDetail = [ProductAttributeDetail]()
    var tempProductvariationDetail = [ProductVariationDetail]()
    var tempProductSurchangeDetail = [ProductSurchageVariationDetail]()
    var tempMeaFields = [ProductItemMetaFieldsDetail]()
    //MARK: Create Shared Instance
    public static let shared = ProductModel()
    private init() {}
    
    //MARK: - Attribute Array Work
    
    func getProductDetailDictionary(productDetails: [ProductAttributeDetail]) -> JSONArray {
        var jsonArray = JSONArray()
        for detail in productDetails {
            var dictValues = JSONArray()
            
            for value in detail.valuesAttribute {
                var dictValue = JSONDictionary()
                
                dictValue["attributeId"] = value.attribute_id
                dictValue["productId"] = value.product_id
                dictValue["attributeType"] = value.attribute_type
                dictValue["attribute_value"] = value.attribute_value
                dictValue["attributeName"] = value.attribute_name
                dictValue["attributeHide"] = value.attribute_hide
                dictValue["attributeRequired"] = value.attribute_required
                dictValue["isSelected"] = value.isSelected
                dictValue["jsonArray"] = value.jsonArray ?? JSONArray()
                
                dictValues.append(dictValue)
            }
            
            var dict = JSONDictionary()
            dict["key"] = detail.key
            dict["values"] = dictValues
            
            jsonArray.append(dict)
        }
        return jsonArray
    }
    
    func getProductItemMetaFieldsDetailDictionary(productDetails: [ProductItemMetaFieldsDetail]) -> JSONArray {
        var jsonArray = JSONArray()
        for detail in productDetails {
            var dictValues = JSONArray()
            
            for value in detail.valuesMetaFields {
                var dictValue = JSONDictionary()
                
                dictValue["name"] = value.name
                dictValue["label"] = value.label
                dictValue["product_lookup_id"] = value.product_lookup_id
                dictValue["value"] = value.value
                dictValue["tempValue"] = value.itemMetaValue
                
                dictValues.append(dictValue)
            }
            
            var dict = JSONDictionary()
            dict["key"] = detail.key
            dict["values"] = dictValues
            
            jsonArray.append(dict)
        }
        return jsonArray
    }
    
    func getProductItemMetaFieldsStruct(jsonArray: JSONArray) -> [ProductItemMetaFieldsDetail] {
        var newProductDetails = [ProductItemMetaFieldsDetail]()
        for dict in jsonArray {
            var newProductDetail = ProductItemMetaFieldsDetail()
            var values = [ItemMetaFieldssModel]()
            
            if let dictValues = dict["values"] as? JSONArray {
                for dictValue in dictValues {
                    var value = ItemMetaFieldssModel()
                    
                    value.name = dictValue["name"] as? String ?? ""
                    value.label = dictValue["label"] as? String ?? ""
                    value.value = dictValue["value"] as? String ?? ""
                    value.product_lookup_id = dictValue["product_lookup_id"] as? String ?? ""
                    value.itemMetaValue = dictValue["tempValue"] as? String ?? ""
                    
                    values.append(value)
                }
            }
            newProductDetail.key = dict["key"] as? String ?? ""
            newProductDetail.valuesMetaFields = values
            newProductDetails.append(newProductDetail)
        }
        return newProductDetails
    }
    
    func getProductDetailStruct(jsonArray: JSONArray) -> [ProductAttributeDetail] {
        var newProductDetails = [ProductAttributeDetail]()
        for dict in jsonArray {
            var newProductDetail = ProductAttributeDetail()
            var values = [AttributesModel]()
            
            if let dictValues = dict["values"] as? JSONArray {
                for dictValue in dictValues {
                    var value = AttributesModel()
                    
                    value.attribute_id = dictValue["attributeId"] as? String ?? ""
                    value.product_id = dictValue["productId"] as? String ?? ""
                    value.attribute_type = dictValue["attributeType"] as? String ?? ""
                    value.attribute_value = dictValue["attribute_value"] as? String ?? ""
                    value.attribute_name = dictValue["attributeName"] as? String ?? ""
                    value.attribute_hide = dictValue["attributeHide"] as? String ?? ""
                    value.attribute_required = dictValue["attributeRequired"] as? String ?? ""
                    value.isSelected = dictValue["isSelected"] as? Bool ?? false
                    value.jsonArray = dictValue["jsonArray"] as? JSONArray ?? JSONArray()

                    values.append(value)
                }
            }
            newProductDetail.key = dict["key"] as? String ?? ""
            newProductDetail.valuesAttribute = values
            newProductDetails.append(newProductDetail)
        }
        return newProductDetails
    }
    func getProductDetailStructForPanyNow(jsonArray: JSONArray,selectJsonArray: JSONArray) -> [ProductAttributeDetail] {
        var newProductDetails = [ProductAttributeDetail]()
//        for dict in jsonArray {
//            var newProductDetail = ProductAttributeDetail()
//            var values = [AttributesModel]()
//            
//            if let dictValues = dict["values"] as? JSONArray {
//                for dictValue in dictValues {
//                    var value = AttributesModel()
//                    
//                    value.attribute_id = dictValue["attributeId"] as? String ?? ""
//                    value.product_id = dictValue["productId"] as? String ?? ""
//                    value.attribute_type = dictValue["attributeType"] as? String ?? ""
//                    value.attribute_value = dictValue["attribute_value"] as? String ?? ""
//                    value.attribute_name = dictValue["attributeName"] as? String ?? ""
//                    value.attribute_hide = dictValue["attributeHide"] as? String ?? ""
//                    value.attribute_required = dictValue["attributeRequired"] as? String ?? ""
//                    value.isSelected = dictValue["isSelected"] as? Bool ?? false
//                    value.jsonArray = dictValue["jsonArray"] as? JSONArray ?? JSONArray()
//
//                    values.append(value)
//                }
//            }else{
//                for data in selectJsonArray {
//                    if dict["attribute_id"] as? String ?? "" == data["attribute_id"] as? String ?? "" {
//                        var value = AttributesModel()
//                        value.attribute_id = dict["attribute_id"] as? String ?? ""
//                        value.product_id = dict["product_id"] as? String ?? ""
//                        value.attribute_type = dict["attribute_type"] as? String ?? ""
//                        value.attribute_value = data["attribute_value"] as? String ?? ""
//                        value.attribute_name = dict["attribute_name"] as? String ?? ""
//                        value.attribute_hide = dict["attribute_hide"] as? String ?? ""
//                        value.attribute_required = dict["attribute_required"] as? String ?? ""
//                        value.isSelected = true
//                        value.jsonArray = dict["attribute_values"] as? JSONArray ?? JSONArray()
//
//                        values.append(value)
//                    }
//                }
//            }
//            newProductDetail.key = dict["key"] as? String ?? ""
//            newProductDetail.valuesAttribute = values
//            newProductDetails.append(newProductDetail)
//        }
        for data in selectJsonArray {
            var newProductDetail = ProductAttributeDetail()
            var values = [AttributesModel]()
            for dict in jsonArray {
                if dict["attribute_id"] as? String ?? "" == data["attribute_id"] as? String ?? "" {
                    var value = AttributesModel()
                    value.attribute_id = dict["attribute_id"] as? String ?? ""
                    value.product_id = dict["product_id"] as? String ?? ""
                    value.attribute_type = dict["attribute_type"] as? String ?? ""
                    value.attribute_value = data["attribute_value"] as? String ?? ""
                    value.attribute_name = dict["attribute_name"] as? String ?? ""
                    value.attribute_hide = dict["attribute_hide"] as? String ?? ""
                    value.attribute_required = dict["attribute_required"] as? String ?? ""
                    value.isSelected = true
                    value.jsonArray = dict["attribute_values"] as? JSONArray ?? JSONArray()

                    values.append(value)
                    newProductDetail.key = dict["key"] as? String ?? ""
                    newProductDetail.valuesAttribute = values
                    newProductDetails.append(newProductDetail)
                }
            }
           
        }
        return newProductDetails
    }
    func parseAttribute(productData: ProductsModel) -> (Bool, [ProductAttributeDetail]?) {
        self.tempProductDetail.removeAll()
        
        
        for attribute in productData.attributesData {
            self.parseAttribute(with: [attribute])
        }
        
        for detail in tempProductDetail {
            if detail.valuesAttribute.count > 1 {
                return (false, nil)
            }
        }
        
        return (true, tempProductDetail)
    }
    
    func parseAttribute(with jsonArray: JSONArray) {
        self.tempProductDetail.append(self.getAttributesVal(with: jsonArray, isSelected: false))
        
        if (tempProductDetail.last?.valuesAttribute.count ?? 0) > 1 {
            return
        }
    }
    
    func getAttributesVal(with jsonArray: JSONArray, isSelected: Bool = false) -> ProductAttributeDetail {
        var productDetail = ProductAttributeDetail()
        var attributes = [AttributesModel]()
        for dict in jsonArray {
            productDetail.key = dict["key"] as? String ?? ""
            
            let attribute_id = dict["attribute_id"] as? String ?? ""
            let product_id = dict["product_id"] as? String ?? ""
            let attribute_type = dict["attribute_type"] as? String ?? ""
            let attribute_value = dict["attribute_value"] as? String ?? ""
            let attribute_name = dict["attribute_name"] as? String ?? ""
            let attribute_hide = dict["attribute_hide"] as? String ?? ""
            
            let attribute_required = dict["attribute_required"] as? String ?? ""
            let jsonArray = dict["attribute_values"] as? JSONArray
            
            let dictJsohArray = addValueInJson(attributedate: jsonArray!)
            
            print(dictJsohArray)
            //attributes.append(AttributesModel())
            attributes.append(AttributesModel(attribute_id: attribute_id, product_id: product_id, attribute_type: attribute_type, attribute_value: attribute_value, attribute_name: attribute_name, attribute_hide: attribute_hide, attribute_required: attribute_required, isSelected: false, jsonArray: dictJsohArray))
        }
        productDetail.valuesAttribute = attributes
        return productDetail
    }
    //MARK: -- Item Meta Fields
       func parseItemMetaFieldsData(productData: ProductsModel) -> (Bool, [ProductItemMetaFieldsDetail]?) {
           self.tempMeaFields.removeAll()
           
           for attribute in productData.itemMetaData {
               self.parseItemMeta(with: [attribute])
           }
           
           for detail in tempMeaFields {
               if detail.valuesMetaFields.count > 1 {
                   return (false, nil)
               }
           }
           
           return (true, tempMeaFields)
       }
       func parseItemMeta(with jsonArray: JSONArray) {
           self.tempMeaFields.append(self.getItemMetaFieldsVal(with: jsonArray))
           
           if (tempMeaFields.last?.valuesMetaFields.count ?? 0) > 1 {
               return
           }
       }
       
       func getItemMetaFieldsVal(with jsonArray: JSONArray) -> ProductItemMetaFieldsDetail {
           var productDetail = ProductItemMetaFieldsDetail()
           var itemMeataFields = [ItemMetaFieldssModel]()
           for dict in jsonArray {
               productDetail.key = dict["key"] as? String ?? ""
               
               let name = dict["name"] as? String ?? ""
               let value = dict["value"] as? String ?? ""
               let label = dict["label"] as? String ?? ""
               let product_lookup_id = dict["product_lookup_id"] as? String ?? ""
               let tempValue = dict["tempValue"] as? String ?? ""
               itemMeataFields.append(ItemMetaFieldssModel(product_lookup_id: product_lookup_id, name: name, value: value, label: label, itemMetaValue: tempValue))
             
           }
           productDetail.valuesMetaFields = itemMeataFields
           return productDetail
       }
   
    //MARK: -- Variation
    func parseVariationData(productData: ProductsModel) -> (Bool, [ProductVariationDetail]?) {
        self.tempProductvariationDetail.removeAll()
        
        for attribute in productData.variationsData {
            self.parseVariation(with: [attribute])
        }
        
        for detail in tempProductvariationDetail {
            if detail.valuesVariation.count > 1 {
                return (false, nil)
            }
        }
        
        return (true, tempProductvariationDetail)
    }
    
    func parseVariation(with jsonArray: JSONArray) {
        self.tempProductvariationDetail.append(self.getVariationVal(with: jsonArray))
        
        if (tempProductvariationDetail.last?.valuesVariation.count ?? 0) > 1 {
            return
        }
    }
    
    func getVariationVal(with jsonArray: JSONArray) -> ProductVariationDetail {
        var productDetail = ProductVariationDetail()
        var variation = [VariationModel]()
        for dict in jsonArray {
            productDetail.key = dict["key"] as? String ?? ""
            
            let variation_id = dict["variation_id"] as? String ?? ""
            let variation_price = dict["variation_price"] as? String ?? ""
            let variation_original_price = dict["variation_original_price"] as? String ?? ""
            let variation_msrp = dict["variation_msrp"] as? String ?? ""
            let variation_price_special = dict["variation_price_special"] as? String ?? ""
            let variation_price_special_date_start = dict["variation_price_special_date_start"] as? String ?? ""
            let variation_price_special_date_end = dict["variation_price_special_date_end"] as? String ?? ""
            let variation_wholesale_price = dict["variation_wholesale_price"] as? String ?? ""
            let variation_price_surcharge = dict["variation_price_surcharge"] as? String ?? ""
            let variation_stock = dict["variation_stock"] as? String ?? ""
            let variation_upc = dict["variation_upc"] as? String ?? ""
            let variation_product_code = dict["variation_product_code"] as? String ?? ""
            let variation_description = dict["variation_description"] as? String ?? ""
            let variation_use_parent_stock = dict["variation_use_parent_stock"] as? String ?? ""
            let variation_taxable = dict["variation_taxable"] as? Bool ?? true
            let variation_use_parent_upc = dict["variation_use_parent_upc"] as? String ?? ""
            let variation_use_parent_price = dict["variation_use_parent_price"] as? String ?? ""
            let jsonArray = dict["variation_attribute"] as? JSONArray
            
            variation.append(VariationModel(variation_id: variation_id, variation_price: variation_price, variation_original_price: variation_original_price, variation_msrp: variation_msrp, variation_price_special: variation_price_special, variation_price_special_date_start: variation_price_special_date_start, variation_price_special_date_end: variation_price_special_date_end, variation_wholesale_price: variation_wholesale_price, variation_price_surcharge: variation_price_surcharge, variation_stock: variation_stock, variation_upc: variation_upc, variation_product_code: variation_product_code, variation_description: variation_description, variation_use_parent_stock: variation_use_parent_stock, variation_taxable: variation_taxable, variation_use_parent_upc: variation_use_parent_upc, variation_use_parent_price: variation_use_parent_price, jsonArray: jsonArray))
            //variation.append(VariationModel(attribute_id: attribute_id, product_id: product_id, attribute_type: attribute_type, attribute_name: attribute_name, attribute_hide: attribute_hide, attribute_required: attribute_required, isSelected: false, jsonArray: dictJsohArray))
        }
        productDetail.valuesVariation = variation
        return productDetail
    }
    
    func getProductDetailVariationDictionary(productDetails: [ProductVariationDetail]) -> JSONArray {
        var jsonArray = JSONArray()
        for detail in productDetails {
            var dictValues = JSONArray()
            
            for value in detail.valuesVariation {
                var dict = JSONDictionary()
                
                dict["variationId"] = value.variation_id
                dict["variationPrice"] = value.variation_price
                dict["variationOriginalPrice"] = value.variation_original_price
                dict["variationMsrp"] = value.variation_msrp
                dict["variationPriceSpecial"] = value.variation_price_special
                dict["variationPriceSpecialDateStart"] = value.variation_price_special_date_start
                dict["variationPriceSpecialDateEnd"] = value.variation_price_special_date_end
                dict["variationWholesalePrice"] = value.variation_wholesale_price
                dict["variationPriceSurcharge"] = value.variation_price_surcharge
                dict["variationStock"] = value.variation_stock
                dict["variationUpc"] = value.variation_upc
                dict["variationProductCode"] = value.variation_product_code
                dict["variationDescription"] = value.variation_description
                dict["variationUseParentStock"] = value.variation_use_parent_stock
                dict["variation_taxable"] = value.variation_taxable
                dict["variationUseParentUpc"] = value.variation_use_parent_upc
                dict["variationUseParentPrice"] = value.variation_use_parent_price
                
//                dictValue["attributeId"] = value.attribute_id
//                dictValue["productId"] = value.product_id
//                dictValue["attributeType"] = value.attribute_type
//                dictValue["attributeName"] = value.attribute_name
//                dictValue["attributeHide"] = value.attribute_hide
//                dictValue["attributeRequired"] = value.attribute_required
//                dictValue["isSelected"] = value.isSelected
                dict["jsonArray"] = value.jsonArray ?? JSONArray()
                
                dictValues.append(dict)
            }
            
            var dict = JSONDictionary()
            dict["key"] = detail.key
            dict["values"] = dictValues
            
            jsonArray.append(dict)
        }
        return jsonArray
    }
    
    func getProductDetailVariationStruct(jsonArray: JSONArray) -> [ProductVariationDetail] {
        var newProductDetails = [ProductVariationDetail]()
        for dict in jsonArray {
            var newProductDetail = ProductVariationDetail()
            var values = [VariationModel]()
            
            if let dictValues = dict["values"] as? JSONArray {
                for dictValue in dictValues {
                    var value = VariationModel()
                    
                    value.variation_id = dictValue["variationId"] as? String ?? ""
                    value.variation_price = dictValue["variationPrice"] as? String ?? ""
                    value.variation_original_price = dictValue["variationOriginalPrice"] as? String ?? ""
                    value.variation_msrp = dictValue["variationMsrp"] as? String ?? ""
                    value.variation_price_special = dictValue["variationPriceSpecial"] as? String ?? ""
                    value.variation_price_special_date_start = dictValue["variationPriceSpecialDateStart"] as? String ?? ""
                    value.variation_price_special_date_end = dictValue["variationPriceSpecialDateEnd"] as? String ?? ""
                    value.variation_wholesale_price = dictValue["variationWholesalePrice"] as? String ?? ""
                    value.variation_price_surcharge = dictValue["variationPriceSurcharge"] as? String ?? ""
                    value.variation_stock = dictValue["variationStock"] as? String ?? ""
                    value.variation_upc = dictValue["variationUpc"] as? String ?? ""
                    value.variation_product_code = dictValue["variationProductCode"] as? String ?? ""
                    value.variation_description = dictValue["variationDescription"] as? String ?? ""
                    value.variation_use_parent_stock = dictValue["variationUseParentStock"] as? String ?? ""
                    value.variation_taxable = dictValue["variation_taxable"] as? Bool ?? true
                    value.variation_use_parent_upc = dictValue["variationUseParentUpc"] as? String ?? ""
                    value.variation_use_parent_price = dictValue["variationUseParentPrice"] as? String ?? ""
                    
//                    value.attribute_id = dictValue["attributeId"] as? String ?? ""
//                    value.product_id = dictValue["productId"] as? String ?? ""
//                    value.attribute_type = dictValue["attributeType"] as? String ?? ""
//                    value.attribute_name = dictValue["attributeName"] as? String ?? ""
//                    value.attribute_hide = dictValue["attributeHide"] as? String ?? ""
//                    value.attribute_required = dictValue["attributeRequired"] as? String ?? ""
//                    value.isSelected = dictValue["isSelected"] as? Bool ?? false
                    value.jsonArray = dictValue["jsonArray"] as? JSONArray ?? JSONArray()
                    
                    values.append(value)
                }
            }
            newProductDetail.key = dict["key"] as? String ?? ""
            newProductDetail.valuesVariation = values
            newProductDetails.append(newProductDetail)
        }
        return newProductDetails
    }
    func getProductDetailVariationStructForPayNOW(jsonArray: JSONArray) -> [ProductVariationDetail] {
        var newProductDetails = [ProductVariationDetail]()
        for dict in jsonArray {
            var newProductDetail = ProductVariationDetail()
            var values = [VariationModel]()
            
            if let dictValues = dict["values"] as? JSONArray {
                for dictValue in dictValues {
                    var value = VariationModel()
                    
                    value.variation_id = dictValue["variationId"] as? String ?? ""
                    value.variation_price = dictValue["variationPrice"] as? String ?? ""
                    value.variation_original_price = dictValue["variationOriginalPrice"] as? String ?? ""
                    value.variation_msrp = dictValue["variationMsrp"] as? String ?? ""
                    value.variation_price_special = dictValue["variationPriceSpecial"] as? String ?? ""
                    value.variation_price_special_date_start = dictValue["variationPriceSpecialDateStart"] as? String ?? ""
                    value.variation_price_special_date_end = dictValue["variationPriceSpecialDateEnd"] as? String ?? ""
                    value.variation_wholesale_price = dictValue["variationWholesalePrice"] as? String ?? ""
                    value.variation_price_surcharge = dictValue["variationPriceSurcharge"] as? String ?? ""
                    value.variation_stock = dictValue["variationStock"] as? String ?? ""
                    value.variation_upc = dictValue["variationUpc"] as? String ?? ""
                    value.variation_product_code = dictValue["variationProductCode"] as? String ?? ""
                    value.variation_description = dictValue["variationDescription"] as? String ?? ""
                    value.variation_use_parent_stock = dictValue["variationUseParentStock"] as? String ?? ""
                    value.variation_taxable = dictValue["variation_taxable"] as? Bool ?? true
                    value.variation_use_parent_upc = dictValue["variationUseParentUpc"] as? String ?? ""
                    value.variation_use_parent_price = dictValue["variationUseParentPrice"] as? String ?? ""
                    
//                    value.attribute_id = dictValue["attributeId"] as? String ?? ""
//                    value.product_id = dictValue["productId"] as? String ?? ""
//                    value.attribute_type = dictValue["attributeType"] as? String ?? ""
//                    value.attribute_name = dictValue["attributeName"] as? String ?? ""
//                    value.attribute_hide = dictValue["attributeHide"] as? String ?? ""
//                    value.attribute_required = dictValue["attributeRequired"] as? String ?? ""
//                    value.isSelected = dictValue["isSelected"] as? Bool ?? false
                    value.jsonArray = dictValue["jsonArray"] as? JSONArray ?? JSONArray()
                    
                    values.append(value)
                }
            }else{
                var value = VariationModel()
                
                value.variation_id = dict["variation_id"] as? String ?? ""
                value.variation_price = dict["variation_price"] as? String ?? ""
                value.variation_original_price = dict["variation_original_price"] as? String ?? ""
                value.variation_msrp = dict["variation_msrp"] as? String ?? ""
                value.variation_price_special = dict["variation_price_special"] as? String ?? ""
                value.variation_price_special_date_start = dict["variation_price_special_date_start"] as? String ?? ""
                value.variation_price_special_date_end = dict["variation_price_special_date_end"] as? String ?? ""
                value.variation_wholesale_price = dict["variation_wholesale_price"] as? String ?? ""
                value.variation_price_surcharge = dict["variation_price_surcharge"] as? String ?? ""
                value.variation_stock = dict["variation_stock"] as? String ?? ""
                value.variation_upc = dict["variation_upc"] as? String ?? ""
                value.variation_product_code = dict["variation_product_code"] as? String ?? ""
                value.variation_description = dict["variation_description"] as? String ?? ""
                value.variation_use_parent_stock = dict["variation_use_parent_stock"] as? String ?? ""
                value.variation_taxable = dict["variation_taxable"] as? Bool ?? true
                value.variation_use_parent_upc = dict["variation_use_parent_upc"] as? String ?? ""
                value.variation_use_parent_price = dict["variation_use_parent_price"] as? String ?? ""
                
//                    value.attribute_id = dictValue["attributeId"] as? String ?? ""
//                    value.product_id = dictValue["productId"] as? String ?? ""
//                    value.attribute_type = dictValue["attributeType"] as? String ?? ""
//                    value.attribute_name = dictValue["attributeName"] as? String ?? ""
//                    value.attribute_hide = dictValue["attributeHide"] as? String ?? ""
//                    value.attribute_required = dictValue["attributeRequired"] as? String ?? ""
//                    value.isSelected = dictValue["isSelected"] as? Bool ?? false
                value.jsonArray = dict["variation_attribute"] as? JSONArray ?? JSONArray()
                
                values.append(value)
            }
            newProductDetail.key = dict["key"] as? String ?? ""
            newProductDetail.valuesVariation = values
            newProductDetails.append(newProductDetail)
        }
        return newProductDetails
    }
    //MARK: -- SurchargeVariation
    func parseSurchargeVariationData(productData: ProductsModel) -> (Bool, [ProductSurchageVariationDetail]?) {
        self.tempProductSurchangeDetail.removeAll()
        
        for attribute in productData.surchagevariationsData {
            self.parseSurchargeVariation(with: [attribute])
        }
        
        for detail in tempProductSurchangeDetail {
            if detail.valuesSurchargeVariation.count > 1 {
                return (false, nil)
            }
        }
        
        return (true, tempProductSurchangeDetail)
    }
    
    func parseSurchargeVariation(with jsonArray: JSONArray) {
        self.tempProductSurchangeDetail.append(self.getSurchargeVariationVal(with: jsonArray))
        
        if (tempProductSurchangeDetail.last?.valuesSurchargeVariation.count ?? 0) > 1 {
            return
        }
    }
    
    func getSurchargeVariationVal(with jsonArray: JSONArray) -> ProductSurchageVariationDetail {
        var productDetail = ProductSurchageVariationDetail()
        var variation = [SurchageModel]()
        for dict in jsonArray {
            productDetail.key = dict["key"] as? String ?? ""
            
            
            let variation_id = dict["variation_id"] as? String ?? ""
            let variation_price = dict["variation_price"] as? String ?? ""
            let variation_original_price = dict["variation_original_price"] as? String ?? ""
            let variation_msrp = dict["variation_msrp"] as? String ?? ""
            let variation_price_special = dict["variation_price_special"] as? String ?? ""
            let variation_price_special_date_start = dict["variation_price_special_date_start"] as? String ?? ""
            let variation_price_special_date_end = dict["variation_price_special_date_end"] as? String ?? ""
            let variation_wholesale_price = dict["variation_wholesale_price"] as? String ?? ""
            let variation_price_surcharge = dict["variation_price_surcharge"] as? String ?? ""
            let variation_stock = dict["variation_stock"] as? String ?? ""
            let variation_upc = dict["variation_upc"] as? String ?? ""
            let variation_product_code = dict["variation_product_code"] as? String ?? ""
            let variation_description = dict["variation_description"] as? String ?? ""
            let variation_use_parent_stock = dict["variation_use_parent_stock"] as? String ?? ""
            let variation_taxable = dict["variation_taxable"] as? Bool ?? true
            let variation_use_parent_upc = dict["variation_use_parent_upc"] as? String ?? ""
            let variation_use_parent_price = dict["variation_use_parent_price"] as? String ?? ""
            let jsonArray = dict["variation_attribute"] as? JSONArray
            let showAdditinalPriceInput = dict["showAdditinalPriceInput"] as? Bool ?? false
            let variation_price_surchargeClone = dict["variation_price_surcharge"] as? String ?? ""
            
            variation.append(SurchageModel(variation_id: variation_id, variation_price: variation_price, variation_original_price: variation_original_price, variation_msrp: variation_msrp, variation_price_special: variation_price_special, variation_price_special_date_start: variation_price_special_date_start, variation_price_special_date_end: variation_price_special_date_end, variation_wholesale_price: variation_wholesale_price, variation_price_surcharge: variation_price_surcharge, variation_price_surchargeClone: variation_price_surchargeClone, variation_stock: variation_stock, variation_upc: variation_upc, variation_product_code: variation_product_code, variation_description: variation_description, variation_use_parent_stock: variation_use_parent_stock, variation_taxable: variation_taxable, variation_use_parent_upc: variation_use_parent_upc, variation_use_parent_price: variation_use_parent_price, showAdditinalPriceInput: showAdditinalPriceInput, jsonArray: jsonArray))
            //variation.append(VariationModel(attribute_id: attribute_id, product_id: product_id, attribute_type: attribute_type, attribute_name: attribute_name, attribute_hide: attribute_hide, attribute_required: attribute_required, isSelected: false, jsonArray: dictJsohArray))
        }
        productDetail.valuesSurchargeVariation = variation
        return productDetail
    }
    
    func getProductDetailSurchargeVariationDictionary(productDetails: [ProductSurchageVariationDetail]) -> JSONArray {
        var jsonArray = JSONArray()
        for detail in productDetails {
            var dictValues = JSONArray()
            
            for value in detail.valuesSurchargeVariation {
                var dict = JSONDictionary()
                
                dict["variationId"] = value.variation_id
                dict["variationPrice"] = value.variation_price
                dict["variationOriginalPrice"] = value.variation_original_price
                dict["variationMsrp"] = value.variation_msrp
                dict["variationPriceSpecial"] = value.variation_price_special
                dict["variationPriceSpecialDateStart"] = value.variation_price_special_date_start
                dict["variationPriceSpecialDateEnd"] = value.variation_price_special_date_end
                dict["variationWholesalePrice"] = value.variation_wholesale_price
                dict["variationPriceSurcharge"] = value.variation_price_surcharge
                dict["variationStock"] = value.variation_stock
                dict["variationUpc"] = value.variation_upc
                dict["variationProductCode"] = value.variation_product_code
                dict["variationDescription"] = value.variation_description
                dict["variationUseParentStock"] = value.variation_use_parent_stock
                dict["variation_taxable"] = value.variation_taxable
                dict["variationUseParentUpc"] = value.variation_use_parent_upc
                dict["variationUseParentPrice"] = value.variation_use_parent_price
                dict["showAdditinalPriceInput"] = value.showAdditinalPriceInput
                dict["variation_price_surchargeClone"] = value.variation_price_surchargeClone
                //                dictValue["attributeId"] = value.attribute_id
                //                dictValue["productId"] = value.product_id
                //                dictValue["attributeType"] = value.attribute_type
                //                dictValue["attributeName"] = value.attribute_name
                //                dictValue["attributeHide"] = value.attribute_hide
                //                dictValue["attributeRequired"] = value.attribute_required
                //                dictValue["isSelected"] = value.isSelected
                dict["jsonArray"] = value.jsonArray ?? JSONArray()
                
                dictValues.append(dict)
            }
            
            var dict = JSONDictionary()
            dict["key"] = detail.key
            dict["values"] = dictValues
            
            jsonArray.append(dict)
        }
        return jsonArray
    }
    
    func getProductDetailSurchargeVariationStruct(jsonArray: JSONArray) -> [ProductSurchageVariationDetail] {
        var newProductDetails = [ProductSurchageVariationDetail]()
        for dict in jsonArray {
            var newProductDetail = ProductSurchageVariationDetail()
            var values = [SurchageModel]()
            
            if let dictValues = dict["values"] as? JSONArray {
                for dictValue in dictValues {
                    var value = SurchageModel()
                    
                    value.variation_id = dictValue["variationId"] as? String ?? ""
                    value.variation_price = dictValue["variationPrice"] as? String ?? ""
                    value.variation_original_price = dictValue["variationOriginalPrice"] as? String ?? ""
                    value.variation_msrp = dictValue["variationMsrp"] as? String ?? ""
                    value.variation_price_special = dictValue["variationPriceSpecial"] as? String ?? ""
                    value.variation_price_special_date_start = dictValue["variationPriceSpecialDateStart"] as? String ?? ""
                    value.variation_price_special_date_end = dictValue["variationPriceSpecialDateEnd"] as? String ?? ""
                    value.variation_wholesale_price = dictValue["variationWholesalePrice"] as? String ?? ""
                    value.variation_price_surcharge = dictValue["variationPriceSurcharge"] as? String ?? ""
                    value.variation_stock = dictValue["variationStock"] as? String ?? ""
                    value.variation_upc = dictValue["variationUpc"] as? String ?? ""
                    value.variation_product_code = dictValue["variationProductCode"] as? String ?? ""
                    value.variation_description = dictValue["variationDescription"] as? String ?? ""
                    value.variation_use_parent_stock = dictValue["variationUseParentStock"] as? String ?? ""
                    value.variation_taxable = dictValue["variation_taxable"] as? Bool ?? true
                    value.variation_use_parent_upc = dictValue["variationUseParentUpc"] as? String ?? ""
                    value.variation_use_parent_price = dictValue["variationUseParentPrice"] as? String ?? ""
                    value.showAdditinalPriceInput = dictValue["showAdditinalPriceInput"] as? Bool ?? false
                    value.variation_price_surchargeClone = dictValue["variation_price_surchargeClone"] as? String
                    
                    //                    value.attribute_id = dictValue["attributeId"] as? String ?? ""
                    //                    value.product_id = dictValue["productId"] as? String ?? ""
                    //                    value.attribute_type = dictValue["attributeType"] as? String ?? ""
                    //                    value.attribute_name = dictValue["attributeName"] as? String ?? ""
                    //                    value.attribute_hide = dictValue["attributeHide"] as? String ?? ""
                    //                    value.attribute_required = dictValue["attributeRequired"] as? String ?? ""
                    //                    value.isSelected = dictValue["isSelected"] as? Bool ?? false
                    value.jsonArray = dictValue["jsonArray"] as? JSONArray ?? JSONArray()
                    
                    values.append(value)
                }
            }
            newProductDetail.key = dict["key"] as? String ?? ""
            newProductDetail.valuesSurchargeVariation = values
            newProductDetails.append(newProductDetail)
        }
        return newProductDetails
    }
    
    func getProductDetailSurchargeVariationStructForPayNOW(jsonArray: JSONArray) -> [ProductSurchageVariationDetail] {
        var newProductDetails = [ProductSurchageVariationDetail]()
        for dict in jsonArray {
            var newProductDetail = ProductSurchageVariationDetail()
            var values = [SurchageModel]()
            
//            if let dictValues = dict["values"] as? JSONArray {
//                for dictValue in dict {
                    var value = SurchageModel()
                    
                    value.variation_id = dict["variation_id"] as? String ?? ""
                    value.variation_price = dict["variation_price"] as? String ?? ""
                    value.variation_original_price = dict["variation_original_price"] as? String ?? ""
                    value.variation_msrp = dict["variation_msrp"] as? String ?? ""
                    value.variation_price_special = dict["variation_price_special"] as? String ?? ""
                    value.variation_price_special_date_start = dict["variation_price_special_date_start"] as? String ?? ""
                    value.variation_price_special_date_end = dict["variation_price_special_date_end"] as? String ?? ""
                    value.variation_wholesale_price = dict["variation_wholesale_price"] as? String ?? ""
                    value.variation_price_surcharge = dict["variation_price_surcharge"] as? String ?? ""
                    value.variation_stock = dict["variation_stock"] as? String ?? ""
                    value.variation_upc = dict["variation_upc"] as? String ?? ""
                    value.variation_product_code = dict["variation_product_code"] as? String ?? ""
                    value.variation_description = dict["variation_description"] as? String ?? ""
                    value.variation_use_parent_stock = dict["variation_use_parent_stock"] as? String ?? ""
                    value.variation_taxable = dict["variation_taxable"] as? Bool ?? true
                    value.variation_use_parent_upc = dict["variation_use_parent_upc"] as? String ?? ""
                    value.variation_use_parent_price = dict["variation_use_parent_price"] as? String ?? ""
                    value.showAdditinalPriceInput = dict["showAdditinalPriceInput"] as? Bool ?? false
                    value.variation_price_surchargeClone = dict["variation_price_surchargeClone"] as? String
                    
                    //                    value.attribute_id = dictValue["attributeId"] as? String ?? ""
                    //                    value.product_id = dictValue["productId"] as? String ?? ""
                    //                    value.attribute_type = dictValue["attributeType"] as? String ?? ""
                    //                    value.attribute_name = dictValue["attributeName"] as? String ?? ""
                    //                    value.attribute_hide = dictValue["attributeHide"] as? String ?? ""
                    //                    value.attribute_required = dictValue["attributeRequired"] as? String ?? ""
                    //                    value.isSelected = dictValue["isSelected"] as? Bool ?? false
                    value.jsonArray = dict["variation_attribute"] as? JSONArray ?? JSONArray()
                    
                    values.append(value)
//                }
//            }
            newProductDetail.key = dict["key"] as? String ?? ""
            newProductDetail.valuesSurchargeVariation = values
            newProductDetails.append(newProductDetail)
        }
        return newProductDetails
    }
    //MARK: -- Json Change
    func addValueInJson(attributedate: JSONArray) -> JSONArray {
        
        var jsonArrayValue = JSONArray()
        let attributeVal = attributedate as [NSDictionary]
        for data in attributeVal {
            if let theJSONData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                
                //Convert Dictionary to String
                let theJSONText = String(data: theJSONData, encoding: .ascii)
                print("JSON string = \(theJSONText!)")
                var dict = convertToDictionary(text: theJSONText!)
                dict!["isSelect"] = false
                
                jsonArrayValue.append(dict!)
            }
        }
        
        return jsonArrayValue
    }
    
    //Convert To Dictionary
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    //MARK: -  last variation code
    
    func getVariation(with jsonArray: JSONArray, isSelected: Bool = false) -> ProductAttributeDetail {
        var productDetail = ProductAttributeDetail()
        var attributes = [Attributes]()
        for dict in jsonArray {
            productDetail.key = dict["key"] as? String ?? ""
            let variationId = dict["variation_id"] as? String ?? ""
            let attributeId = String(describing: (dict["id"] as? Int ?? 0))
            let attributeName = dict["value"] as? String ?? ""
            let variationPrice = Double(dict["variation_price"] as? String ?? "") ?? 0
            let jsonArray = dict["children"] as? JSONArray
            attributes.append(Attributes(variationId: variationId, attributeId: attributeId, attributeName: attributeName, attributeValueId: "", price: variationPrice, isRadio: true, isSelected: isSelected, jsonArray: jsonArray))
        }
       // productDetail.values = attributes
        return productDetail
    }
    
    func getSurchargeValue(with dict: JSONDictionary) -> [Attributes] {
        var attributes = [Attributes]()
        for (key, value) in dict {
            if let valueDict = value as? JSONDictionary {
                let variationId = valueDict["variation_id"] as? String ?? ""
                let attributeId = valueDict["attribute_id"] as? String ?? ""
                let attributeValueId = valueDict["attribute_value_id"] as? String ?? ""
                let variationPrice = Double(valueDict["price_surcharge"] as? String ?? "") ?? 0
                attributes.append(Attributes(variationId: variationId, attributeId: attributeId, attributeName: key, attributeValueId: attributeValueId, price: variationPrice, isRadio: false, isSelected: false, jsonArray: nil))
            }
        }
        return attributes.sorted(by: { (a1, a2) -> Bool in
            return a1.attributeName < a2.attributeName
        })
    }
}

