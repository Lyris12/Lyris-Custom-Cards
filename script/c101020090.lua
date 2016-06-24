--ファイヤーストローム・ツイスター
local id,ref=GIR()
function ref.start(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.activate)
	c:RegisterEffect(e1)
end
function ref.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa88)
end
function ref.dfilter(c)
	return c:IsFacedown() or not (c:IsSetCard(0xa88) and c:IsType(TYPE_MONSTER))
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(ref.filter,tp,LOCATION_MZONE,0,nil)
	local fg=g:Filter(Card.IsType,nil,TYPE_FUSION)
	local q=Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,c)
	local b1=q and g:GetCount()>1
	local b2=q and g:GetCount()==5 and fg:GetCount()==2
	if chk==0 then return b1 or b2 end
	if b1 and b2 then
		local opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
		e:SetLabel(opt)
	elseif b1 then
		Duel.SelectOption(tp,aux.Stringid(id,1))
		e:SetLabel(0)
	else
		Duel.SelectOption(tp,aux.Stringid(id,2))
		e:SetLabel(1)
	end
	local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if e:GetLabel()==0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,3,0,0)
	else
		local des=dg:Filter(ref.dfilter,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,des,des:GetCount(),0,0)
	end
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if dg:GetCount()<3 and ct==0 then return end
	if ct~=0 then
		local des=dg:Filter(ref.dfilter,nil)
		Duel.Destroy(des,REASON_EFFECT)
	else
		local des=dg:Select(tp,3,3,nil)
		Duel.HintSelection(des)
		Duel.Destroy(des,REASON_EFFECT,LOCATION_DECKSHF)
	end
end
