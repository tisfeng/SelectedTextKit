# 本地化

- 所有用户可见的 UI 文本都必须本地化。不要在 SwiftUI、AppKit、脚本或打包的 web
  资源中硬编码可见字符串。
- 当前仓库没有 String Catalog 或 `.strings` 资源；本规则在修改示例应用的用户可见
  文本或引入本地化资源时适用，不要求本次治理迁移改造 UI。
- 引入 String Catalog 后，以工程实际采用的 catalog 为权威。新增 key 或改变其含义时，
  检查其中的 locale，并更新所有受影响的 locale。
- 使用 String Catalog 时，在 UI 和字符串 API 中优先直接使用静态 key。
- 不要动态构建本地化 key，也不要拼接本地化片段。应将完整句子本地化，并传入
  运行时参数。
- 使用小写、点号分隔的 key，并按 `<scope>.<category>.<subcategory>.<element>`
  形式使用 snake_case 片段。
- 引入本地化流程时同步根目录 `README.md` 中的贡献说明，不引用源仓库的翻译指南。
