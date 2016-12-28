--created & coded by Lyris
--機光襲雷竜－ニューン
function c101010038.initial_effect(c)
c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c101010038.fscondition)
	e1:SetOperation(c101010038.fsoperation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c101010038.descon)
	e2:SetOperation(c101010038.desop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,101010038)
	e4:SetTarget(c101010038.sptg)
	e4:SetOperation(c101010038.spop)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c101010038.matcheck)
	e3:SetLabelObject(e4)
	c:RegisterEffect(e3)
end
function c101010038.ffilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_DRAGON)
end
function c101010038.fscondition(e,g,gc,chkf)
	if g==nil then return false end
	if gc then
		local mg=g:Filter(Card.IsFusionSetCard,gc,0x167)
		return (gc:IsFusionSetCard(0x167) and mg:IsExists(c101010038.ffilter,1,nil)) or (c101010038.ffilter(gc) and mg:GetCount()>0)
	end
	local fs=false
	local mg=g:Filter(Card.IsFusionSetCard,nil,0x167)
	if mg:IsExists(aux.FConditionCheckF,1,nil,chkf) then fs=true end
	return mg:IsExists(c101010038.ffilter,1,nil) and mg:GetCount()>0 and (fs or chkf==PLAYER_NONE)
end
function c101010038.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	if gc then
		local sg=eg:Filter(Card.IsFusionSetCard,gc,0x167)
		local g=Group.FromCards(gc)
		for i=1,5 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			g:Merge(sg:Select(tp,1,1,nil))
			sg:Remove(Card.IsCode,nil,g:GetFirst():GetCode())
			if i==5 or sg:FilterCount(Card.IsFusionSetCard,gc,0x167)==0 or not Duel.SelectYesNo(tp,aux.Stringid(101010038,0)) then break end
		end
		Duel.SetFusionMaterial(g)
		return
	end
	local sg1=eg:Filter(c101010038.ffilter,nil)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then g1=sg1:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg1:Select(tp,1,1,nil) end
	local sg2=eg:Filter(Card.IsFusionSetCard,nil,0x167)
	local g2=Group.CreateGroup()
	for i=1,5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g2:Merge(sg2:Select(tp,1,1,nil))
		sg2:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		if i==5 or sg2:FilterCount(Card.IsFusionSetCard,nil,0x167)==0 or not Duel.SelectYesNo(tp,aux.Stringid(101010038,0)) then break end
	end
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end
function c101010038.matcheck(e,c)
	local ct=e:GetHandler():GetMaterialCount()-2
	e:GetLabelObject():SetLabel(ct)
end
function c101010038.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,ct)
	local ds=Duel.GetDecktopGroup(tp,math.ceil(ct/2))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ds,ds:GetCount(),tp,LOCATION_DECK)
end
function c101010038.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct<=0 then return end
	local d1=Duel.Draw(tp,ct,REASON_EFFECT)
	local d2=Duel.Draw(1-tp,ct,REASON_EFFECT)
	local g=Duel.GetDecktopGroup(tp,math.ceil(ct/2))
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.DisableShuffleCheck()
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c101010038.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c101010038.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
