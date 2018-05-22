{-# LANGUAGE OverloadedStrings #-}
import Hakyll

main :: IO ()
main = hakyllWith config $ do
  match "css/*" $ do
    route   idRoute
    compile compressCssCompiler

  match "templates/*" $ compile templateBodyCompiler

  match ("images/*" .||. "public.key" .||. "CNAME") $ do
    route   idRoute
    compile copyFileCompiler

  match "index.html" $ do
    route idRoute
    compile $ getResourceBody
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  match (fromList ["cv.md"]) $ do
    route $ setExtension "html"
    compile $ pandocCompiler
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls


  where config = defaultConfiguration { deployCommand = "./deploy.sh" }

--  match (fromList ["about.rst", "contact.markdown"]) $ do
--    route   $ setExtension "html"
--    compile $ pandocCompiler
--      >>= loadAndApplyTemplate "templates/default.html" defaultContext
--      >>= relativizeUrls
--
--  match "posts/*" $ do
--    route $ setExtension "html"
--    compile $ pandocCompiler
--      >>= loadAndApplyTemplate "templates/post.html"    postCtx
--      >>= loadAndApplyTemplate "templates/default.html" postCtx
--      >>= relativizeUrls
--
--  create ["archive.html"] $ do
--    route idRoute
--    compile $ do
--      posts <- recentFirst =<< loadAll "posts/*"
--      let archiveCtx =
--            listField "posts" postCtx (return posts) <>
--            constField "title" "Archives"            <>
--            defaultContext
--
--      makeItem ""
--        >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
--        >>= loadAndApplyTemplate "templates/default.html" archiveCtx
--        >>= relativizeUrls
--
--
--  match "index.html" $ do
--    route idRoute
--    compile $ getResourceString
--      >>= loadAndApplyTemplate "templates/default.html" defaultContext
--      >>= relativizeUrls
--
--      --posts <- recentFirst =<< loadAll "posts/*"
--      --let indexCtx =
--      --      listField "posts" postCtx (return posts) `mappend`
--      --      constField "title" "Home"                `mappend`
--      --      defaultContext
--
--      --getResourceBody
--      --  >>= applyAsTemplate indexCtx
--      --  >>= loadAndApplyTemplate "templates/default.html" indexCtx
--      --  >>= relativizeUrls


--------------------------------------------------------------------------------
--postCtx :: Context String
--postCtx =
--    dateField "date" "%B %e, %Y" `mappend`
--    defaultContext
