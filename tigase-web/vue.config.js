
module.exports = {

  productionSourceMap: false,

  devServer: {
    proxy: {
      '/api/chat': {
        target: 'http://192.168.0.101:5280',
        pathRewrite:{
          '^/api/chat':''
        }
      }
    }
  }

}
