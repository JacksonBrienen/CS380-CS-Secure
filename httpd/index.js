
window.addEventListener('load', () => {
    /**
     * @type {HTMLCanvasElement}
     */
    const canvas = document.getElementById("graph-canvas");
    canvas.width = canvas.getBoundingClientRect().width;
    canvas.height = canvas.getBoundingClientRect().height;


    /**
     * @type {CanvasRenderingContext2D}
     */
    const g = canvas.getContext("2d");

    const nodes = [];
    const edges = [];

    const draw = ()=> {
        g.save();
        g.setTransform(1, 0, 0, 1, 0, 0);
        g.clearRect(0, 0, canvas.width, canvas.height);
        g.restore();
        for(let e of edges) {
            e.draw(g);
        }

        for(let n of nodes) {
            n.draw(g);
        }
        if(selectedNode !== null) {
            selectedNode.setStyle(selectedStyle);
            selectedNode.draw(g);
            selectedNode.setStyle(defaultStyle);
        }
    };

    fetch('./graph/classes.json')
        .then((response) => response.json())
        .then((obj) =>{
            for(let n of obj['nodes']) {
                const tmp = new Node(new Vector(n['position']['x'], n['position']['y']));
                tmp.setText(n['text']);
                tmp.setStyle(defaultStyle);
                nodes.push(tmp);
            }

            for(let e of obj['edges']) {
                edges.push(new Edge(nodes[e['from']], nodes[e['to']]));
            }
            draw();
        });

    // handling mouse interactions

    let mousedown = false;
    let dragOffset = {x: 0, y: 0};
    let translation = {x: 0, y: 0};
    let defaultStyle = NodeStyle.default().copy();
    defaultStyle.backgroundColor = '#ABB2B9';
    let selectedStyle = NodeStyle.default().copy();
    selectedStyle.borderColor = '#218838';
    selectedStyle.backgroundColor = '#ABB2B9';
    let selectedNode = null;
    let hovered = false;


    canvas.addEventListener('mousedown', (e)=>{
        mousedown = true;
        dragOffset = {x: e.offsetX, y: e.offsetY};

        let newNode = null;
        const mousePos = new Vector(e.offsetX - translation.x, e.offsetY - translation.y);
        for(let i = nodes.length - 1; i > -1; i--) {
            if(nodes[i].ellipse.containsVector(mousePos)) {
                newNode = nodes[i];
                nodes.splice(i, 1);
                nodes.push(newNode);
                break;
            }
        }
        if(selectedNode !== newNode) {
            selectedNode = newNode;
            draw();
        }
    });

    canvas.addEventListener('mouseup', (e)=>{
        mousedown = false;
    });

    canvas.addEventListener('mouseleave', (e)=>{
        mousedown = false;
    })

    canvas.addEventListener('mousemove', (e)=>{
        if(mousedown) {
            if(selectedNode != null) {
                selectedNode.ellipse.center.x += e.offsetX - dragOffset.x;
                selectedNode.ellipse.center.y += e.offsetY - dragOffset.y;
                dragOffset = {x: e.offsetX, y: e.offsetY};
                draw();
            } else {
                g.translate(e.offsetX - dragOffset.x, e.offsetY - dragOffset.y);
                translation.x += e.offsetX - dragOffset.x;
                translation.y += e.offsetY - dragOffset.y;
                dragOffset = {x: e.offsetX, y: e.offsetY};
                draw();
            }
        } else {
            const mousePos = new Vector(e.offsetX - translation.x, e.offsetY - translation.y);
            let oldHovered = hovered;
            hovered = false;
            for(let i = nodes.length - 1; i > -1; i--) {
                if(nodes[i].ellipse.containsVector(mousePos)) {
                    hovered = true;
                    nodes[i].setStyle(selectedStyle);
                    draw();
                    nodes[i].setStyle(defaultStyle);
                    break;
                }
            }
            if(hovered !== oldHovered) {
                draw();
            }
        }
    });
    window.addEventListener('resize', ()=> {
        canvas.width = canvas.getBoundingClientRect().width;
        canvas.height = canvas.getBoundingClientRect().height;
        draw();
    });
});
