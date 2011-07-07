class Public::BaseController < CMSController

  layout :set_layout
  helper :cms_engine, :navigation, :easy_forms

  protected
  
    def set_layout 
      params[:format] == 'xml' ? false : 'public'
    end


    #
    # Methods to help rendering pages, may be used by controllers other than PagesController
    #
    
    def render_page
      load_shared_pages
      set_meta_data
      set_page_types_ivars
      add_page_breadcrumbs
      render_page_template
    end
    
    def load_page
      if params[:slug_path].is_a? Array
        @slug_path, suffix = params[:slug_path].join('/').split('.') 
        params[:format] = suffix ? suffix : "html"
      else
        @slug_path, suffix = params[:slug_path].split('.')
        params[:format] = suffix ? suffix : "html"
      end
      @page, @extra_params = Page.find_by_slug_path_with_extra_path_params(@slug_path, admin_preview_mode?)
      if admin_preview_mode?
        @page.preview_latest_version
      end
      params.update(@extra_params)
      @page
     end
  
    # Set page title and metadata
    def set_meta_data
      @page_title = @page.meta_title.blank? ? @page.title : @page.meta_title
      unless @page.meta_keywords.blank?
        @meta_keywords = @page.meta_keywords
      end
      unless @page.meta_description.blank?
        @meta_description = @page.meta_description
      end
    end
  
    # Load other pages required by templates
    def load_shared_pages
      @root_page = @page.root_ancestor
      @news_rss = Page.find(:first, :conditions => ["type = 'NewsIndex'"])
    end
  
    # Set other instance variables required by the page type
    def set_page_types_ivars
      instance_variable_set("@#{@page.class.to_s.underscore}", @page)
      if @page.can_have_comments?
        @comments = @page.comments.approved
      end
      @page.render(params).each do |k,v|
        instance_variable_set("@#{k}", v)
      end
    end    

    # Render the appropriate template for the page type
    # AC May 2010: 
    # I have added a set of layout params that can be defined in the PageType model as:
    # self.page_layout = 'public' or any other layout that you have defined.
    # MT July 2010 added request.xhr check
    def render_page_template
       if @page.children_restricted? && !logged_in?
         render :action => 'restricted', :layout => @page.page_layout
       else
         respond_to do |wants|
           wants.html do
             if request.xhr?
               render :template => @page.public_template, :layout => false
             else
               render :template => @page.public_template, :layout => @page.page_layout
             end
           end
           wants.rss do
             render :template => @page.public_template, :layout => false
           end
         end
       end          
     end
    
    
    # Breadcrumb navigation
    def homepage?
      @page and @page.slug == 'home'
    end
    helper_method :homepage?
    
    def breadcrumbs
      @breadcrumbs ||= []
    end
    helper_method :breadcrumbs

    def add_breadcrumb(text, url = nil)
      breadcrumbs << [text, url]
    end

    def add_page_breadcrumbs
      return if homepage?
      pages_for_crumbs = @page.ancestors
      pages_for_crumbs.shift
      add_breadcrumb 'Home', homepage_url
      unless pages_for_crumbs.empty?
        pages_for_crumbs.each do |p|
          add_breadcrumb p.nav_title, url_for_page(p)
        end
      end
      if @extra_crumb
        add_breadcrumb @page.nav_title, url_for_page(@page)
        add_breadcrumb @extra_crumb
      else
        add_breadcrumb @page.nav_title
      end
    end

    def admin_preview_mode?
      current_user && current_user.has_role?(:cms_user) && params[:admin_preview] == 'true'
    end
    helper_method :admin_preview_mode?
end
