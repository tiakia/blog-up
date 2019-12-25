---
title: 基于antd封装的模态框新增编辑组件
abbrlink: 54457
date: 2019-12-11 17:07:06
tags: antd
categories: javascript
---
在项目中有很多类似的功能，比如说新增的时候弹出一个模态框，填写表单后提交完成新增，或者是编辑的时候弹出模态框，填写表单后提交完成编辑。所以我基于`antd`做了一个封装,可以根据`JSON`数据来生成一个，表单提交模态框。
<!-- more -->
先上截图：
![tpms-select](/images/antModal-1.png)
![tpms-treeselect](/images/antModal-2.png)

从截图可以看出生成的表单模态框中表单类型可以是下拉选择、树形选择也可以是单选框、多选框或者是文件上传，而生成这些只需要我们写一个`JSON`对象就可以。

## JSON对象

```javascript
    let formProps = {
      modalTitle: "添加需求意向",
      record: [],
      title: {
        name: "标题",
        actual: "title"
      },
      desc: {
        name: "描述",
        actual: "desc",
        rules: [{ required: false, message: "请填写描述信息" }]
      },
      projNo: {
        name: "项目编号",
        actual: "proj_no"
      },
      pmUserNo: {
        name: "项目经理工号",
        actual: "pm_user_no",
        inputProps: {
          type: "treeSelect"
        },
        rules: [{ required: false, message: "请选择项目经理工号" }],
        options: this.state.proGroup
      },
      acptUserNo: {
        name: "受理人员工编号",
        actual: "acpt_user_no",
        inputProps: {
          type: "treeSelect"
        },
        rules: [{ required: false, message: "请选择受理人员工编号" }],
        options: this.state.proGroup
      },
      dept_no: {
        name: "提出部门",
        actual: "dept_no"
      },
      attach: {
          name: "附件",
          actual: "attach",
          inputProps: {
            type: "upload",
            uploadProps: {}
         }
      },
      status: {
        name: "状态",
        actual: "status",
        inputProps: {
          type: "select",
          selectProps: { selName: "arg_name", selVal: "arg_value" }
        },
        rules: [{ required: false, message: "请选择状态" }],
        options: status
      }
    };
```
我们来解释一下每个字段的意思：

- `modalTitle`: 这个是展示模态框标题的
- `record`: 如果是新增那么`record`值为空对象或者数组，如果为编辑，那值为对象，对象的`key`为每个表单对象的`actual`字段
- 针对每个表单对象来说，以上面的`status`举例:
  - 表单对象的Key(`status`)可以随意，真实取值的是`actual`字段的值（这里建议写成一样的）
  - `name` `FormItem`组件的`label`
  - `actual`表单提交到后端时的字段名称
  - `inputProps`标识表单类型和其他表单属性
  ```javascript
    areaID: {
      name: '区域编号',
      rules: [{ required: true }],
      inputProps: { disabled: true, type: 'number' },
      actual: 'area_id',
    },
  ```
      要注意的是，如果表单为下拉选，可以在这里标明`options`的`key`和`value`。
  ```javascript
  inputProps: {
      type: "select",
      selectProps: { selName: "arg_name", selVal: "arg_value" }
    },
  ```
  - `rules`表单的规则
  - `options`如果表单为下拉选的时候需要，对于`status`表单对象来说，他的`options`应该是这样的：
  ```javascript
const status = [
  { arg_value: "1", arg_name: "提交" },
  { arg_value: "2", arg_name: "受理" },
  { arg_value: "3", arg_name: "分配" },
  { arg_value: "9", arg_name: "拒绝" }
];
  ```
      它的`key`,`value`正好对应`inputProps`重点`selName`,`selVal`
  - 如果多个表单对象是展示在一行的那么这几个表单对象应该这样写：
  ```javascript
  ....
   groups3: {
      revenuesV0: {
        name: `${moment().format('YYYY')}年财政总收入`,
        actual: 'revenues_v0',
      },
      revenuesV1: {
        name: `${moment()
          .subtract(1, 'y')
          .format('YYYY')}年财政总收入`,
        actual: 'revenues_v1',
      },
      revenuesV2: {
        name: `${moment()
          .subtract(2, 'y')
          .format('YYYY')}年财政总收入`,
        actual: 'revenues_v2',
      },
   },
  ...
  ```
      重要的`groups`,至于后面的数字只是为了标明第几组。

## 封装代码

```javascript ModalForm.js
import React from "react";
import {
  Form,
  Modal,
  Select,
  Row,
  Col,
  Input,
  DatePicker,
  Upload,
  Button,
  Icon,
  Spin,
  InputNumber,
  Radio,
  TreeSelect
} from "antd";
import styles from "./ModalForm.less";

const { TextArea } = Input;

const radioStyle = {
  display: "block",
  height: "30px",
  lineHeight: "30px"
};
function judgeInputType(inputProps, options) {
  switch (inputProps && inputProps.type) {
    case "treeSelect":
      return (
        <TreeSelect
          treeData={options && options.length && options.length > 0 && options}
        ></TreeSelect>
      );
    case "select":
      return (
        <Select>
          {options.map((val, idx) => (
            <Select.Option key={idx} value={val[inputProps.selectProps.selVal]}>
              {val[inputProps.selectProps.selName]}
            </Select.Option>
          ))}
        </Select>
      );
    case "date":
      return <DatePicker style={{ width: "100%" }} />;
    case "textarea":
      return <TextArea autosize />;
    case "radio":
      return (
        <Radio.Group style={{ marginLeft: "30px" }}>
          {options.map((addr, idx) => {
            return (
              <Radio style={radioStyle} value={addr.id} key={addr.id || idx}>
                选址-
                {idx + 1}
              </Radio>
            );
          })}
        </Radio.Group>
      );
    case "upload":
      return (
        <Upload {...inputProps.upLoadProps}>
          <Button>
            <Icon type="upload" /> 点击上传
          </Button>
        </Upload>
      );
    case "number":
      return <InputNumber style={{ width: "200px" }} />;
    default:
      return <Input {...(inputProps && inputProps)} />;
  }
}

const WrapperModalFrom = Form.create()(
  class ModalForm extends React.PureComponent {
    render() {
      const {
        form: { getFieldDecorator },
        formData,
        isLoading,
        style,
        width,
        formItemLayout,
        isSpinLoading = false
      } = this.props;
      console.log("formData: ", formData);
      const { record, modalTitle, ...formOther } = formData && formData;
      return (
        <Modal
          title={modalTitle}
          visible={this.props.visible}
          onOk={this.props.onOk}
          onCancel={this.props.onCancel}
          width={width}
          confirmLoading={isLoading}
          style={style}
          className={styles.modalForm}
        >
          <Spin spinning={isSpinLoading}>
            <Form>
              {formData &&
                Object.keys(formOther).map((item, idx) => {
                  if (/groups/gi.test(item)) {
                    return (
                      <Row key={idx} gutter={10}>
                        {Object.keys(formOther[item]).map((subItem, subIdx) => (
                          <Col
                            span={24 / Object.keys(formOther[item]).length}
                            key={idx - subIdx}
                          >
                            <Form.Item
                              label={formOther[item][subItem].name}
                              {...formItemLayout}
                            >
                              {getFieldDecorator(
                                `${formOther[item][subItem].actual}`,
                                {
                                  rules: [
                                    ...(formOther[item][subItem].rules || [])
                                  ],
                                  initialValue: record[subItem] || ""
                                }
                              )(
                                judgeInputType(
                                  formOther[item][subItem].inputProps,
                                  formOther[item][subItem].options
                                )
                              )}
                            </Form.Item>
                          </Col>
                        ))}
                      </Row>
                    );
                  } else {
                    return (
                      <Form.Item
                        label={formOther[item].name}
                        key={idx}
                        style={formOther[item].styles && formOther[item].styles}
                        {...formItemLayout}
                      >
                        {getFieldDecorator(`${formOther[item].actual}`, {
                          rules: [...(formOther[item].rules || [])],
                          initialValue: record[item]
                            ? formOther[item].inputProps &&
                              formOther[item].inputProps.type === "select"
                              ? String(record[item])
                              : record[item]
                            : ""
                        })(
                          judgeInputType(
                            formOther[item].inputProps,
                            formOther[item].options
                          )
                        )}
                      </Form.Item>
                    );
                  }
                })}
            </Form>
          </Spin>
        </Modal>
      );
    }
  }
);

export default WrapperModalFrom;
````


- 使用：

```javascript
 <WrapModalFrom
   ref={formProps}
   visible={modalShow}
   onOk={() => handleCreate()}
   onCancel={(e: any) => {
     console.log(e);
     setModalShow(false);
   }}
   formData={formData}
   isLoading={effects['specialMerchant/add']}
   isSpinLoading={effects['specialMerchant/getType'] || false}
   width={'50%'}
   formItemLayout={formItemLayout}
   style={{ top: '30px', paddingBottom: '0' }}
 />

```

- `formProps`

```javascript
const formProps = useRef(null);
// 或者是React.createRef()
// 用来获取`modal`表单提交中的`form`相关属性
```
例如： `handelCreate()`
```javascript
handleCreate = () => {
    formProps.current.validateFields((err,values) => {
        if(err) {
            return;
        }
        console.log('接收到的值为： ',values);
    })
}
```
