--created & coded by Lyris
--AdSSスペクトル・スナイパー
function c101010281.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure2(c,nil,aux.FilterBoolFunction(Card.IsType,TYPE_TUNER))
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101010281,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c101010281.spcost)
	e3:SetTarget(c101010281.sptg)
	e3:SetOperation(c101010281.spop)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c101010281.tg)
	e1:SetOperation(c101010281.lvop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c101010281.sfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c101010281.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t={}
	local i=1
	local p=1
	local lv=e:GetHandler():GetLevel()
	for i=1,8 do 
		if i>2 and lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010281,1))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c101010281.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c101010281.cfilter(c,ck)
	return c:IsAbleToGraveAsCost() and c:IsLevelAbove(1)
end
function c101010281.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c101010281.cfilter,tp,LOCATION_MZONE,0,c)
	if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c101010281.sptgfil,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel(),mg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010281.spfil1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c)
	local sc=g:GetFirst()
	e:SetLabelObject(sc)
	local lv=c:GetLevel()
	local g1=Group.FromCards(c)
	local tglv=sc:GetLevel()
	while lv<tglv do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g2=mg:FilterSelect(tp,c101010281.spfil2,1,1,nil,tglv-lv,mg,sc)
			local gc=g2:GetFirst()
			lv=lv+gc:GetLevel()
			mg:RemoveCard(gc)
			g1:AddCard(gc)
	end
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c101010281.sptgfil(c,e,tp,lv,mg)
	return c:IsSetCard(0x5cd) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and mg:CheckWithSumEqual(Card.GetOriginalLevel,c:GetLevel()-lv,1,63,c) and c:IsCanBeEffectTarget(e)
end
function c101010281.spfil1(c,e,tp,tc)
	if c:IsSetCard(0x5cd) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e) then
		local mg=Duel.GetMatchingGroup(c101010281.cfilter,tp,LOCATION_MZONE,0,tc)
		return mg:IsExists(c101010281.spfil2,1,nil,c:GetLevel()-tc:GetLevel(),mg,c)
	else
		return false
	end
end
function c101010281.spfil2(c,limlv,mg,sc)
	local fg=mg:Clone()
	fg:RemoveCard(c)
	local newlim=limlv-c:GetLevel()
	if newlim==0 then return true else return fg:CheckWithSumEqual(Card.GetOriginalLevel,newlim,1,63,sc) end
end
function c101010281.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local sc=e:GetLabelObject()
	Duel.SetTargetCard(sc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sc,1,0,0)
end
function c101010281.spop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
