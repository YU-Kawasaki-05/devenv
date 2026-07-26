# Math Guide

## 数式レンダリングの仕組み

MathJax (mathjax-full) を Node.js で使い、LaTeX → SVG → PNG に変換してPPTXに埋め込む。

## インストール

```bash
cd ~/develop/slide-gen
npm install
# mathjax-full と sharp は package.json に含まれている
```

## yaml での書き方

### math layout（数式専用スライド）
```yaml
- layout: math
  title: "ガウス分布"
  math:
    - "f(x) = \\frac{1}{\\sigma\\sqrt{2\\pi}} e^{-\\frac{(x-\\mu)^2}{2\\sigma^2}}"
  content: "μ: 平均、σ: 標準偏差"
```

### two-column 内の数式
```yaml
- layout: two-column
  title: "損失関数"
  left:
    type: math
    math: "L_{MSE} = \\frac{1}{n}\\sum_{i=1}^{n}(y_i - \\hat{y}_i)^2"
  right:
    type: bullets
    items:
      - "回帰問題に適する"
      - "外れ値に敏感"
```

## 使えるLaTeX

MathJax の TeX パッケージをすべて有効化しているため、標準的な数学記法はほぼ使える。

```latex
# 分数
\frac{分子}{分母}

# 総和・積分
\sum_{i=1}^{n} x_i
\int_0^\infty f(x)\,dx

# 行列
\begin{pmatrix} a & b \\ c & d \end{pmatrix}

# ギリシャ文字
\alpha, \beta, \gamma, \sigma, \mu, \lambda

# 極限
\lim_{x \to \infty} f(x)

# 偏微分
\frac{\partial f}{\partial x}

# ベクトル・太字
\mathbf{w}, \boldsymbol{\theta}

# 条件付き確率
P(A \mid B)

# 集合
\in, \subset, \cup, \cap, \mathbb{R}^n
```

## 制限

| 制限 | 内容 |
|------|------|
| 1スライドの数式数 | 最大3式推奨 |
| 複雑な数式 | 長い行列は2スライドに分割 |
| カスタムマクロ | 未対応（\newcommand 不可） |
| TikZ / PGF | 非対応 |

## 注意事項

- YAML の `math` フィールドには LaTeX を **`$$` で囲まず** 書く
- ダブルクォートで囲む場合は `\\` でバックスラッシュをエスケープ
- シングルクォートで囲む場合はエスケープ不要

```yaml
# NG
math: "$$\frac{a}{b}$$"

# OK（ダブルクォート）
math: "\\frac{a}{b}"

# OK（シングルクォート）
math: '\frac{a}{b}'
```
